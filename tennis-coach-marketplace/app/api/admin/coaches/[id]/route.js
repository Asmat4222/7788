import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../../../../lib/auth';
import { prisma } from '../../../../../lib/db';

export async function PATCH(req, { params }) {
  const session = await getServerSession(authOptions);
  if (!session || session.user.role !== 'admin') {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { approved } = await req.json();
  const coach = await prisma.coach.update({
    where: { id: params.id },
    data: { approved: Boolean(approved) },
  });

  return NextResponse.json(coach);
}
