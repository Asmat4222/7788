'use client';

import { useState } from 'react';
import { signIn } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { Trophy, Eye, EyeOff } from 'lucide-react';
import toast from 'react-hot-toast';

export default function LoginPage() {
  const router = useRouter();
  const [form, setForm] = useState({ email: '', password: '' });
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    const result = await signIn('credentials', {
      email: form.email,
      password: form.password,
      redirect: false,
    });

    setLoading(false);

    if (result?.error) {
      toast.error('Invalid email or password');
    } else {
      toast.success('Welcome back!');
      router.push('/');
      router.refresh();
    }
  };

  const fillDemo = (role) => {
    const demos = {
      student: { email: 'student@demo.com', password: 'student123' },
      coach: { email: 'rafael@tenniscoach.com', password: 'coach123' },
      admin: { email: 'admin@tennismarket.com', password: 'admin123' },
    };
    setForm(demos[role]);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 px-4 py-12">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <Link href="/" className="inline-flex items-center gap-2 text-green-600 font-bold text-2xl mb-2">
            <Trophy className="w-7 h-7" />
            TennisCoach
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 mt-2">Welcome back</h1>
          <p className="text-gray-500">Sign in to your account</p>
        </div>

        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
          {/* Demo quick login */}
          <div className="mb-6">
            <p className="text-xs text-gray-500 mb-2 text-center">Quick demo login:</p>
            <div className="flex gap-2">
              {['student', 'coach', 'admin'].map((role) => (
                <button
                  key={role}
                  type="button"
                  onClick={() => fillDemo(role)}
                  className="flex-1 text-xs border border-gray-200 rounded-lg py-1.5 hover:border-green-400 hover:text-green-600 transition-colors capitalize"
                >
                  {role}
                </button>
              ))}
            </div>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input
                type="email"
                required
                value={form.email}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
                className="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                placeholder="you@example.com"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Password</label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  required
                  value={form.password}
                  onChange={(e) => setForm({ ...form, password: e.target.value })}
                  className="w-full border border-gray-200 rounded-lg px-3 py-2.5 pr-10 text-sm focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            <div className="flex justify-end">
              <Link href="/forgot-password" className="text-sm text-green-600 hover:underline">
                Forgot password?
              </Link>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full btn-primary py-3 disabled:opacity-60 disabled:cursor-not-allowed"
            >
              {loading ? 'Signing in...' : 'Sign In'}
            </button>
          </form>
        </div>

        <p className="text-center text-sm text-gray-600 mt-6">
          Don&apos;t have an account?{' '}
          <Link href="/register" className="text-green-600 font-semibold hover:underline">
            Sign up free
          </Link>
        </p>
      </div>
    </div>
  );
}
