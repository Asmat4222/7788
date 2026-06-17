import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '../../../../lib/auth';
import { prisma } from '../../../../lib/db';

export async function PATCH(req, { params }) {
  const session = await getServerSession(authOptions);
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });

  const { status } = await req.json();
  const allowed = ['cancelled', 'confirmed', 'completed'];
  if (!allowed.includes(status)) {
    return NextResponse.json({ error: 'Invalid status' }, { status: 400 });
  }

  const booking = await prisma.booking.findUnique({ where: { id: params.id } });
  if (!booking) return NextResponse.json({ error: 'Not found' }, { status: 404 });

  const updated = await prisma.booking.update({
    where: { id: params.id },
    data: { status },
  });

  return NextResponse.json(updated);
}
