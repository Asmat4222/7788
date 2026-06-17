import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../../lib/auth';
import { prisma } from '../../../lib/db';

export async function GET(req) {
  const { searchParams } = new URL(req.url);
  const coachId = searchParams.get('coachId');
  if (!coachId) return NextResponse.json({ error: 'coachId required' }, { status: 400 });

  const slots = await prisma.availability.findMany({
    where: { coachId },
    orderBy: { dayOfWeek: 'asc' },
  });

  return NextResponse.json(slots);
}

export async function POST(req) {
  const session = await getServerSession(authOptions);
  if (!session || session.user.role !== 'coach') {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const coach = await prisma.coach.findUnique({ where: { userId: session.user.id } });
  if (!coach) return NextResponse.json({ error: 'Coach not found' }, { status: 404 });

  const { slots } = await req.json();

  await prisma.availability.deleteMany({ where: { coachId: coach.id } });
  const created = await prisma.availability.createMany({
    data: slots.map((s) => ({ ...s, coachId: coach.id })),
  });

  return NextResponse.json(created);
}
