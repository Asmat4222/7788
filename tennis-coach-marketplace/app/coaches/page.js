'use client';

import { useState, useEffect, Suspense } from 'react';
import { useSearchParams } from 'next/navigation';
import CoachCard from '../../components/CoachCard';
import SearchFilters from '../../components/SearchFilters';
import { SlidersHorizontal } from 'lucide-react';

function CoachesContent() {
  const searchParams = useSearchParams();
  const [coaches, setCoaches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showFilters, setShowFilters] = useState(false);
  const [filters, setFilters] = useState({
    search: searchParams.get('search') || '',
    location: searchParams.get('location') || '',
    maxPrice: 200,
    minRating: '',
    specialty: searchParams.get('specialty') || '',
  });

  useEffect(() => {
    fetchCoaches();
  }, [filters]);

  const fetchCoaches = async () => {
    setLoading(true);
    const params = new URLSearchParams();
    if (filters.search) params.set('search', filters.search);
    if (filters.location) params.set('location', filters.location);
    if (filters.maxPrice < 200) params.set('maxPrice', filters.maxPrice);
    if (filters.minRating) params.set('minRating', filters.minRating);
    if (filters.specialty) params.set('specialty', filters.specialty);

    const res = await fetch(`/api/coaches?${params}`);
    const data = await res.json();
    setCoaches(data);
    setLoading(false);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 py-10">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Find Tennis Coaches</h1>
        <p className="text-gray-500">{loading ? '...' : `${coaches.length} coaches available`}</p>
      </div>

      <div className="flex gap-8">
        {/* Sidebar filters - desktop */}
        <aside className="hidden lg:block w-72 flex-shrink-0">
          <SearchFilters filters={filters} onChange={setFilters} />
        </aside>

        <div className="flex-1">
          {/* Mobile filter toggle */}
          <button
            className="lg:hidden flex items-center gap-2 mb-4 btn-secondary text-sm"
            onClick={() => setShowFilters(!showFilters)}
          >
            <SlidersHorizontal className="w-4 h-4" />
            {showFilters ? 'Hide Filters' : 'Show Filters'}
          </button>

          {showFilters && (
            <div className="lg:hidden mb-6">
              <SearchFilters filters={filters} onChange={setFilters} />
            </div>
          )}

          {loading ? (
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
              {Array.from({ length: 6 }).map((_, i) => (
                <div key={i} className="card animate-pulse">
                  <div className="h-48 bg-gray-200" />
                  <div className="p-5 space-y-3">
                    <div className="h-4 bg-gray-200 rounded w-3/4" />
                    <div className="h-3 bg-gray-200 rounded w-1/2" />
                    <div className="h-8 bg-gray-200 rounded" />
                  </div>
                </div>
              ))}
            </div>
          ) : coaches.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
              {coaches.map((coach) => (
                <CoachCard key={coach.id} coach={coach} />
              ))}
            </div>
          ) : (
            <div className="text-center py-20 text-gray-400">
              <div className="text-6xl mb-4">🎾</div>
              <h3 className="text-xl font-semibold text-gray-600 mb-2">No coaches found</h3>
              <p>Try adjusting your filters</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default function CoachesPage() {
  return (
    <Suspense>
      <CoachesContent />
    </Suspense>
  );
}
