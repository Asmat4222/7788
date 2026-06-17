import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../../lib/auth';
import { prisma } from '../../../lib/db';

export async function GET() {
  const session = await getServerSession(authOptions);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const where =
    session.user.role === 'coach'
      ? {
          coach: { userId: session.user.id },
        }
      : { studentId: session.user.id };

  const bookings = await prisma.booking.findMany({
    where,
    include: {
      coach: { include: { user: { select: { name: true } } } },
      student: { select: { name: true, email: true } },
      review: true,
    },
    orderBy: { date: 'desc' },
  });

  return NextResponse.json(bookings);
}

export async function POST(req) {
  const session = await getServerSession(authOptions);
  if (!session || session.user.role !== 'student') {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { coachId, date, startTime, endTime, notes, totalPrice } = await req.json();

  if (!coachId || !date || !startTime || !endTime) {
    return NextResponse.json({ error: 'Missing required fields' }, { status: 400 });
  }

  const coach = await prisma.coach.findUnique({ where: { id: coachId } });
  if (!coach || !coach.approved) {
    return NextResponse.json({ error: 'Coach not available' }, { status: 400 });
  }

  const booking = await prisma.booking.create({
    data: {
      studentId: session.user.id,
      coachId,
      date: new Date(date),
      startTime,
      endTime,
      totalPrice: totalPrice || coach.hourlyRate,
      notes,
      status: 'pending',
    },
  });

  return NextResponse.json(booking, { status: 201 });
}
