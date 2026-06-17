import { NextResponse } from 'next/server';
import { prisma } from '../../../lib/db';

export async function GET(req) {
  const { searchParams } = new URL(req.url);
  const search = searchParams.get('search') || '';
  const location = searchParams.get('location') || '';
  const maxPrice = searchParams.get('maxPrice') ? Number(searchParams.get('maxPrice')) : undefined;
  const minRating = searchParams.get('minRating') ? Number(searchParams.get('minRating')) : undefined;
  const specialty = searchParams.get('specialty') || '';

  const where = {
    approved: true,
    ...(location && { location: { contains: location } }),
    ...(maxPrice !== undefined && { hourlyRate: { lte: maxPrice } }),
    ...(minRating !== undefined && { rating: { gte: minRating } }),
    ...(search && {
      OR: [
        { user: { name: { contains: search } } },
        { bio: { contains: search } },
        { location: { contains: search } },
      ],
    }),
    ...(specialty && { specialties: { contains: specialty } }),
  };

  const coaches = await prisma.coach.findMany({
    where,
    include: { user: { select: { name: true, email: true } } },
    orderBy: { rating: 'desc' },
  });

  return NextResponse.json(coaches);
}
