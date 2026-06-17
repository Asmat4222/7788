'use client';

import { Search, MapPin, DollarSign, Star, Filter } from 'lucide-react';

export default function SearchFilters({ filters, onChange }) {
  const handleChange = (key, value) => {
    onChange({ ...filters, [key]: value });
  };

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
      <div className="flex items-center gap-2 mb-4 text-gray-700 font-semibold">
        <Filter className="w-4 h-4" />
        Filters
      </div>

      <div className="space-y-5">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Search</label>
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Coach name or keyword..."
              value={filters.search || ''}
              onChange={(e) => handleChange('search', e.target.value)}
              className="w-full pl-9 pr-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Location</label>
          <div className="relative">
            <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="City, State..."
              value={filters.location || ''}
              onChange={(e) => handleChange('location', e.target.value)}
              className="w-full pl-9 pr-3 py-2 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-green-500 focus:border-transparent outline-none"
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Max Price: ${filters.maxPrice || 200}/hr
          </label>
          <input
            type="range"
            min={30}
            max={200}
            step={5}
            value={filters.maxPrice || 200}
            onChange={(e) => handleChange('maxPrice', Number(e.target.value))}
            className="w-full accent-green-600"
          />
          <div className="flex justify-between text-xs text-gray-400 mt-1">
            <span>$30</span>
            <span>$200</span>
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Min Rating</label>
          <select
            value={filters.minRating || ''}
            onChange={(e) => handleChange('minRating', e.target.value ? Number(e.target.value) : '')}
            className="w-full border border-gray-200 rounded-lg py-2 px-3 text-sm focus:ring-2 focus:ring-green-500 outline-none"
          >
            <option value="">Any rating</option>
            <option value="4.5">4.5+ ⭐</option>
            <option value="4">4.0+ ⭐</option>
            <option value="3.5">3.5+ ⭐</option>
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Skill Level</label>
          <select
            value={filters.specialty || ''}
            onChange={(e) => handleChange('specialty', e.target.value)}
            className="w-full border border-gray-200 rounded-lg py-2 px-3 text-sm focus:ring-2 focus:ring-green-500 outline-none"
          >
            <option value="">All levels</option>
            <option value="Beginner">Beginner</option>
            <option value="Intermediate">Intermediate</option>
            <option value="Advanced">Advanced</option>
            <option value="Kids">Kids</option>
            <option value="Competitive">Competitive</option>
          </select>
        </div>

        <button
          onClick={() => onChange({ search: '', location: '', maxPrice: 200, minRating: '', specialty: '' })}
          className="w-full text-sm text-gray-500 hover:text-gray-700 underline"
        >
          Clear all filters
        </button>
      </div>
    </div>
  );
}
