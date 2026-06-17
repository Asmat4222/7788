import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../../../lib/auth';
import { prisma } from '../../../../lib/db';

export async function GET() {
  const session = await getServerSession(authOptions);
  if (!session || session.user.role !== 'admin') {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const [coaches, users, bookings] = await Promise.all([
    prisma.coach.findMany({
      include: { user: { select: { name: true, email: true } } },
      orderBy: { createdAt: 'desc' },
    }),
    prisma.user.findMany({
      select: { id: true, name: true, email: true, role: true, createdAt: true },
      orderBy: { createdAt: 'desc' },
    }),
    prisma.booking.findMany({
      include: {
        student: { select: { name: true } },
        coach: { include: { user: { select: { name: true } } } },
      },
      orderBy: { createdAt: 'desc' },
      take: 50,
    }),
  ]);

  return NextResponse.json({ coaches, users, bookings });
}
