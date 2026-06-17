'use client';

import { Star } from 'lucide-react';

export default function StarRating({ rating, maxStars = 5, size = 'sm', interactive = false, onChange }) {
  const sizeClass = size === 'sm' ? 'w-4 h-4' : 'w-6 h-6';

  return (
    <div className="flex gap-0.5">
      {Array.from({ length: maxStars }).map((_, i) => (
        <Star
          key={i}
          className={`${sizeClass} ${
            i < Math.floor(rating) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'
          } ${interactive ? 'cursor-pointer hover:text-yellow-400' : ''}`}
          onClick={() => interactive && onChange && onChange(i + 1)}
        />
      ))}
    </div>
  );
}
