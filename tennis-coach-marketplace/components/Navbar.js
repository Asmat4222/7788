'use client';

import Link from 'next/link';
import { useSession, signOut } from 'next-auth/react';
import { useState } from 'react';
import { Menu, X, Trophy } from 'lucide-react';

export default function Navbar() {
  const { data: session } = useSession();
  const [menuOpen, setMenuOpen] = useState(false);

  const dashboardPath =
    session?.user?.role === 'admin'
      ? '/dashboard/admin'
      : session?.user?.role === 'coach'
      ? '/dashboard/coach'
      : '/dashboard/student';

  return (
    <nav className="bg-white border-b border-gray-200 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <Link href="/" className="flex items-center gap-2 font-bold text-xl text-green-600">
            <Trophy className="w-6 h-6" />
            TennisCoach
          </Link>

          <div className="hidden md:flex items-center gap-6">
            <Link href="/coaches" className="text-gray-600 hover:text-green-600 font-medium transition-colors">
              Find Coaches
            </Link>
            {session ? (
              <>
                <Link href={dashboardPath} className="text-gray-600 hover:text-green-600 font-medium transition-colors">
                  Dashboard
                </Link>
                <button
                  onClick={() => signOut({ callbackUrl: '/' })}
                  className="btn-secondary text-sm"
                >
                  Sign Out
                </button>
              </>
            ) : (
              <>
                <Link href="/login" className="text-gray-600 hover:text-green-600 font-medium transition-colors">
                  Sign In
                </Link>
                <Link href="/register" className="btn-primary text-sm">
                  Get Started
                </Link>
              </>
            )}
          </div>

          <button className="md:hidden" onClick={() => setMenuOpen(!menuOpen)}>
            {menuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {menuOpen && (
          <div className="md:hidden pb-4 space-y-2">
            <Link href="/coaches" className="block py-2 text-gray-600 hover:text-green-600" onClick={() => setMenuOpen(false)}>
              Find Coaches
            </Link>
            {session ? (
              <>
                <Link href={dashboardPath} className="block py-2 text-gray-600" onClick={() => setMenuOpen(false)}>
                  Dashboard
                </Link>
                <button onClick={() => signOut({ callbackUrl: '/' })} className="block py-2 text-red-500">
                  Sign Out
                </button>
              </>
            ) : (
              <>
                <Link href="/login" className="block py-2 text-gray-600" onClick={() => setMenuOpen(false)}>
                  Sign In
                </Link>
                <Link href="/register" className="block btn-primary text-center" onClick={() => setMenuOpen(false)}>
                  Get Started
                </Link>
              </>
            )}
          </div>
        )}
      </div>
    </nav>
  );
}
