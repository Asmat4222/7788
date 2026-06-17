'use client';

import { useRouter } from 'next/navigation';
import { useState } from 'react';
import { Search, MapPin } from 'lucide-react';

export default function HeroSection() {
  const router = useRouter();
  const [location, setLocation] = useState('');

  const handleSearch = (e) => {
    e.preventDefault();
    const params = location ? `?location=${encodeURIComponent(location)}` : '';
    router.push(`/coaches${params}`);
  };

  return (
    <section className="relative bg-gradient-to-br from-green-700 via-green-600 to-green-500 text-white overflow-hidden">
      <div className="absolute inset-0 opacity-10">
        <div className="absolute top-10 left-10 w-40 h-40 rounded-full border-4 border-white" />
        <div className="absolute bottom-10 right-20 w-64 h-64 rounded-full border-4 border-white" />
        <div className="absolute top-1/2 left-1/2 w-20 h-20 rounded-full border-2 border-white" />
      </div>

      <div className="relative max-w-7xl mx-auto px-4 py-24 text-center">
        <div className="inline-block bg-white/20 backdrop-blur-sm text-white text-sm font-medium px-4 py-1.5 rounded-full mb-6">
          🎾 #1 Tennis Coaching Marketplace
        </div>
        <h1 className="text-5xl md:text-6xl font-extrabold mb-6 leading-tight">
          Find Your Perfect<br />
          <span className="text-yellow-300">Tennis Coach</span>
        </h1>
        <p className="text-xl text-green-100 mb-10 max-w-2xl mx-auto">
          Book professional tennis coaches in your city. Beginners to competitive players — we have coaches for every level.
        </p>

        <form onSubmit={handleSearch} className="max-w-2xl mx-auto">
          <div className="bg-white rounded-xl p-2 flex gap-2 shadow-2xl">
            <div className="flex-1 relative">
              <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Enter your city (e.g. New York)"
                value={location}
                onChange={(e) => setLocation(e.target.value)}
                className="w-full pl-10 pr-4 py-3 text-gray-800 rounded-lg focus:outline-none text-base"
              />
            </div>
            <button type="submit" className="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg font-semibold flex items-center gap-2 transition-colors">
              <Search className="w-4 h-4" />
              Search
            </button>
          </div>
        </form>

        <div className="flex flex-wrap justify-center gap-6 mt-12 text-sm text-green-100">
          {['500+ Certified Coaches', '10,000+ Sessions Booked', 'Verified Reviews', 'Instant Booking'].map((stat) => (
            <div key={stat} className="flex items-center gap-1.5">
              <span className="text-yellow-300">✓</span> {stat}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
