'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Trophy, Mail } from 'lucide-react';
import toast from 'react-hot-toast';

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState('');
  const [sent, setSent] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    // In production, trigger email sending here
    setSent(true);
    toast.success('If an account exists, a reset link has been sent.');
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 px-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <Link href="/" className="inline-flex items-center gap-2 text-green-600 font-bold text-2xl">
            <Trophy className="w-7 h-7" />
            TennisCoach
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 mt-2">Reset your password</h1>
          <p className="text-gray-500">Enter your email to receive a reset link</p>
        </div>

        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
          {sent ? (
            <div className="text-center py-4">
              <Mail className="w-16 h-16 text-green-500 mx-auto mb-4" />
              <h3 className="font-bold text-gray-900 mb-2">Check your email</h3>
              <p className="text-gray-500 text-sm">
                We&apos;ve sent a password reset link to <strong>{email}</strong>
              </p>
              <Link href="/login" className="btn-primary inline-block mt-6">
                Back to Sign In
              </Link>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Email address</label>
                <input
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm focus:ring-2 focus:ring-green-500 outline-none"
                  placeholder="you@example.com"
                />
              </div>
              <button type="submit" className="w-full btn-primary py-3">
                Send Reset Link
              </button>
              <Link href="/login" className="block text-center text-sm text-gray-500 hover:text-gray-700">
                ← Back to sign in
              </Link>
            </form>
          )}
        </div>
      </div>
    </div>
  );
}
