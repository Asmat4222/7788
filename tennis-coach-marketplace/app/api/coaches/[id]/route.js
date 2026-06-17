import { NextResponse } from 'next/server';
import { prisma } from '../../../../lib/db';

export async function GET(req, { params }) {
  const coach = await prisma.coach.findUnique({
    where: { id: params.id },
    include: {
      user: { select: { name: true, email: true } },
      reviews: { include: { user: { select: { name: true } } }, orderBy: { createdAt: 'desc' }, take: 10 },
      availability: { orderBy: { dayOfWeek: 'asc' } },
    },
  });

  if (!coach) return NextResponse.json({ error: 'Not found' }, { status: 404 });
  return NextResponse.json(coach);
}
