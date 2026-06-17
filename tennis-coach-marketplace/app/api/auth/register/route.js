import { NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { prisma } from '../../../../lib/db';

export async function POST(req) {
  try {
    const { name, email, password, role } = await req.json();

    if (!name || !email || !password) {
      return NextResponse.json({ error: 'All fields are required' }, { status: 400 });
    }

    if (password.length < 6) {
      return NextResponse.json({ error: 'Password must be at least 6 characters' }, { status: 400 });
    }

    const allowedRoles = ['student', 'coach'];
    const userRole = allowedRoles.includes(role) ? role : 'student';

    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) {
      return NextResponse.json({ error: 'Email already in use' }, { status: 400 });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: { name, email, password: hashedPassword, role: userRole },
    });

    if (userRole === 'coach') {
      await prisma.coach.create({
        data: {
          userId: user.id,
          bio: '',
          location: '',
          hourlyRate: 50,
          specialties: JSON.stringify([]),
          approved: false,
        },
      });
    }

    return NextResponse.json({ id: user.id, name: user.name, email: user.email, role: user.role });
  } catch (err) {
    console.error('[register]', err);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}
