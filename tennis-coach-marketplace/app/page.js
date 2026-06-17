import Link from 'next/link';
import HeroSection from '../components/HeroSection';
import CoachCard from '../components/CoachCard';
import { prisma } from '../lib/db';
import { Users, Star, Calendar, Shield } from 'lucide-react';

async function getFeaturedCoaches() {
  try {
    return await prisma.coach.findMany({
      where: { approved: true },
      include: { user: true },
      orderBy: { rating: 'desc' },
      take: 6,
    });
  } catch {
    return [];
  }
}

const categories = [
  { label: 'Beginner', icon: '🌱', desc: 'Learn the basics from scratch' },
  { label: 'Intermediate', icon: '🎯', desc: 'Improve your game' },
  { label: 'Advanced', icon: '🏆', desc: 'Compete at the next level' },
  { label: 'Kids', icon: '⭐', desc: 'Fun sessions for juniors' },
];

const stats = [
  { icon: Users, value: '500+', label: 'Certified Coaches' },
  { icon: Calendar, value: '10K+', label: 'Sessions Booked' },
  { icon: Star, value: '4.8', label: 'Average Rating' },
  { icon: Shield, value: '100%', label: 'Verified Coaches' },
];

export default async function HomePage() {
  const coaches = await getFeaturedCoaches();

  return (
    <div>
      <HeroSection />

      {/* Stats */}
      <section className="bg-white border-b">
        <div className="max-w-7xl mx-auto px-4 py-10 grid grid-cols-2 md:grid-cols-4 gap-6">
          {stats.map(({ icon: Icon, value, label }) => (
            <div key={label} className="text-center">
              <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-2">
                <Icon className="w-6 h-6 text-green-600" />
              </div>
              <div className="text-3xl font-extrabold text-gray-900">{value}</div>
              <div className="text-sm text-gray-500">{label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* Categories */}
      <section className="max-w-7xl mx-auto px-4 py-16">
        <h2 className="text-3xl font-bold text-gray-900 mb-2">Browse by Category</h2>
        <p className="text-gray-500 mb-8">Find the right coach for your level</p>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {categories.map((cat) => (
            <Link
              key={cat.label}
              href={`/coaches?specialty=${cat.label}`}
              className="card p-6 text-center hover:shadow-md hover:border-green-200 transition-all group"
            >
              <div className="text-4xl mb-3">{cat.icon}</div>
              <h3 className="font-bold text-gray-900 group-hover:text-green-600">{cat.label}</h3>
              <p className="text-sm text-gray-500 mt-1">{cat.desc}</p>
            </Link>
          ))}
        </div>
      </section>

      {/* Featured Coaches */}
      <section className="max-w-7xl mx-auto px-4 pb-16">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-3xl font-bold text-gray-900 mb-1">Featured Coaches</h2>
            <p className="text-gray-500">Top-rated coaches on our platform</p>
          </div>
          <Link href="/coaches" className="btn-secondary text-sm hidden md:block">
            View All →
          </Link>
        </div>

        {coaches.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {coaches.map((coach) => (
              <CoachCard key={coach.id} coach={coach} />
            ))}
          </div>
        ) : (
          <div className="text-center py-16 text-gray-400">
            <div className="text-6xl mb-4">🎾</div>
            <p className="text-lg">No coaches yet. Run the seed script to add demo coaches.</p>
          </div>
        )}

        <div className="text-center mt-8 md:hidden">
          <Link href="/coaches" className="btn-primary">View All Coaches</Link>
        </div>
      </section>

      {/* CTA */}
      <section className="bg-gradient-to-r from-green-600 to-green-700 text-white">
        <div className="max-w-4xl mx-auto px-4 py-16 text-center">
          <h2 className="text-3xl font-bold mb-4">Are You a Tennis Coach?</h2>
          <p className="text-green-100 mb-8 text-lg">Join our platform and grow your coaching business. Connect with students in your area.</p>
          <Link href="/register?role=coach" className="bg-white text-green-700 font-bold px-8 py-3 rounded-lg hover:bg-green-50 transition-colors inline-block">
            Apply as Coach
          </Link>
        </div>
      </section>
    </div>
  );
}
