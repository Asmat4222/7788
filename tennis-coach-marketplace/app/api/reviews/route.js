import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../../lib/auth';
import { prisma } from '../../../lib/db';

export async function POST(req) {
  const session = await getServerSession(authOptions);
  if (!session || session.user.role !== 'student') {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { bookingId, coachId, rating, comment } = await req.json();

  if (!bookingId || !coachId || !rating || !comment) {
    return NextResponse.json({ error: 'Missing fields' }, { status: 400 });
  }

  if (rating < 1 || rating > 5) {
    return NextResponse.json({ error: 'Rating must be 1-5' }, { status: 400 });
  }

  const booking = await prisma.booking.findUnique({ where: { id: bookingId } });
  if (!booking || booking.studentId !== session.user.id) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });
  }

  const existing = await prisma.review.findUnique({ where: { bookingId } });
  if (existing) {
    return NextResponse.json({ error: 'Review already submitted' }, { status: 400 });
  }

  const review = await prisma.review.create({
    data: { userId: session.user.id, coachId, bookingId, rating, comment },
  });

  // Update coach aggregate rating
  const reviews = await prisma.review.findMany({ where: { coachId } });
  const avgRating = reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
  await prisma.coach.update({
    where: { id: coachId },
    data: { rating: Math.round(avgRating * 10) / 10, totalReviews: reviews.length },
  });

  return NextResponse.json(review, { status: 201 });
}
