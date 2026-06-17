import Link from 'next/link';
import Image from 'next/image';
import StarRating from './StarRating';
import { MapPin, Clock, Award } from 'lucide-react';

export default function CoachCard({ coach }) {
  const specialties = typeof coach.specialties === 'string'
    ? JSON.parse(coach.specialties)
    : coach.specialties;

  const avatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(coach.user?.name || 'Coach')}&background=16a34a&color=fff&size=200`;

  return (
    <div className="card hover:shadow-md transition-shadow duration-200 group">
      <div className="relative">
        <div className="h-48 bg-gradient-to-br from-green-100 to-green-200 flex items-center justify-center">
          <Image
            src={coach.profileImage || avatarUrl}
            alt={coach.user?.name || 'Coach'}
            width={100}
            height={100}
            className="rounded-full border-4 border-white shadow-md"
          />
        </div>
      </div>

      <div className="p-5">
        <div className="flex items-start justify-between mb-2">
          <div>
            <h3 className="font-bold text-gray-900 text-lg group-hover:text-green-600 transition-colors">
              {coach.user?.name}
            </h3>
            <div className="flex items-center gap-1 text-sm text-gray-500">
              <MapPin className="w-3.5 h-3.5" />
              {coach.location}
            </div>
          </div>
          <div className="text-right">
            <span className="text-2xl font-bold text-green-600">${coach.hourlyRate}</span>
            <span className="text-gray-400 text-sm">/hr</span>
          </div>
        </div>

        <div className="flex items-center gap-2 mb-3">
          <StarRating rating={coach.rating} />
          <span className="text-sm text-gray-600 font-medium">{coach.rating.toFixed(1)}</span>
          <span className="text-sm text-gray-400">({coach.totalReviews} reviews)</span>
        </div>

        <div className="flex items-center gap-1 text-sm text-gray-500 mb-3">
          <Award className="w-3.5 h-3.5 text-green-500" />
          {coach.experience} years experience
        </div>

        <p className="text-sm text-gray-600 line-clamp-2 mb-4">{coach.bio}</p>

        <div className="flex flex-wrap gap-1.5 mb-4">
          {specialties.slice(0, 3).map((s) => (
            <span key={s} className="badge bg-green-50 text-green-700">
              {s}
            </span>
          ))}
        </div>

        <Link
          href={`/coaches/${coach.id}`}
          className="btn-primary w-full text-center block text-sm"
        >
          View Profile
        </Link>
      </div>
    </div>
  );
}
