import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../../../lib/auth';
import { prisma } from '../../../../lib/db';

export async function GET() {
  const session = await getServerSession(authOptions);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const coach = await prisma.coach.findUnique({
    where: { userId: session.user.id },
    include: { user: { select: { name: true, email: true } } },
  });

  if (!coach) return NextResponse.json({ error: 'Coach profile not found' }, { status: 404 });
  return NextResponse.json(coach);
}

export async function PUT(req) {
  const session = await getServerSession(authOptions);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const { bio, location, hourlyRate, experience } = await req.json();

  const coach = await prisma.coach.update({
    where: { userId: session.user.id },
    data: { bio, location, hourlyRate: Number(hourlyRate), experience: Number(experience) },
  });

  return NextResponse.json(coach);
}
