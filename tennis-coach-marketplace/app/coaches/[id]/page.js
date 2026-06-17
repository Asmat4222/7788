import { prisma } from '../../../lib/db';
import { notFound } from 'next/navigation';
import Image from 'next/image';
import Link from 'next/link';
import StarRating from '../../../components/StarRating';
import ReviewCard from '../../../components/ReviewCard';
import { MapPin, Award, Clock, DollarSign, CheckCircle } from 'lucide-react';

async function getCoach(id) {
  return prisma.coach.findUnique({
    where: { id },
    include: {
      user: true,
      reviews: {
        include: { user: true },
        orderBy: { createdAt: 'desc' },
        take: 10,
      },
      availability: { orderBy: { dayOfWeek: 'asc' } },
    },
  });
}

const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

export default async function CoachProfilePage({ params }) {
  const coach = await getCoach(params.id);
  if (!coach) notFound();

  const specialties = JSON.parse(coach.specialties || '[]');
  const avatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(coach.user.name)}&background=16a34a&color=fff&size=200`;

  return (
    <div className="max-w-6xl mx-auto px-4 py-10">
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Left: Profile */}
        <div className="lg:col-span-2 space-y-6">
          {/* Header */}
          <div className="card p-6">
            <div className="flex items-start gap-6">
              <Image
                src={coach.profileImage || avatarUrl}
                alt={coach.user.name}
                width={120}
                height={120}
                className="rounded-full border-4 border-green-100"
              />
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-1">
                  <h1 className="text-2xl font-bold text-gray-900">{coach.user.name}</h1>
                  {coach.approved && (
                    <CheckCircle className="w-5 h-5 text-green-500" title="Verified Coach" />
                  )}
                </div>
                <div className="flex items-center gap-1 text-gray-500 mb-2">
                  <MapPin className="w-4 h-4" />
                  {coach.location}
                </div>
                <div className="flex items-center gap-3">
                  <StarRating rating={coach.rating} />
                  <span className="font-semibold">{coach.rating.toFixed(1)}</span>
                  <span className="text-gray-400">({coach.totalReviews} reviews)</span>
                </div>
                <div className="flex flex-wrap gap-2 mt-3">
                  {specialties.map((s) => (
                    <span key={s} className="badge bg-green-50 text-green-700">{s}</span>
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-3 gap-4">
            {[
              { icon: Award, label: 'Experience', value: `${coach.experience} yrs` },
              { icon: DollarSign, label: 'Hourly Rate', value: `$${coach.hourlyRate}` },
              { icon: Clock, label: 'Response Time', value: '< 1 hour' },
            ].map(({ icon: Icon, label, value }) => (
              <div key={label} className="card p-4 text-center">
                <Icon className="w-6 h-6 text-green-500 mx-auto mb-1" />
                <div className="font-bold text-lg text-gray-900">{value}</div>
                <div className="text-sm text-gray-500">{label}</div>
              </div>
            ))}
          </div>

          {/* Bio */}
          <div className="card p-6">
            <h2 className="text-lg font-bold text-gray-900 mb-3">About</h2>
            <p className="text-gray-600 leading-relaxed">{coach.bio}</p>
          </div>

          {/* Availability */}
          {coach.availability.length > 0 && (
            <div className="card p-6">
              <h2 className="text-lg font-bold text-gray-900 mb-3">Weekly Availability</h2>
              <div className="grid grid-cols-3 md:grid-cols-6 gap-2">
                {coach.availability.map((slot) => (
                  <div key={slot.id} className="text-center bg-green-50 rounded-lg p-2">
                    <div className="font-semibold text-green-700 text-sm">{DAYS[slot.dayOfWeek]}</div>
                    <div className="text-xs text-gray-500">{slot.startTime}–{slot.endTime}</div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Reviews */}
          <div className="card p-6">
            <h2 className="text-lg font-bold text-gray-900 mb-4">
              Reviews ({coach.totalReviews})
            </h2>
            {coach.reviews.length > 0 ? (
              <div className="space-y-4">
                {coach.reviews.map((review) => (
                  <ReviewCard key={review.id} review={review} />
                ))}
              </div>
            ) : (
              <p className="text-gray-400 text-center py-8">No reviews yet</p>
            )}
          </div>
        </div>

        {/* Right: Booking card */}
        <aside>
          <div className="card p-6 sticky top-24">
            <div className="text-3xl font-bold text-gray-900 mb-1">
              ${coach.hourlyRate}
              <span className="text-base text-gray-400 font-normal">/hour</span>
            </div>
            <StarRating rating={coach.rating} />
            <p className="text-sm text-gray-500 mt-1 mb-6">{coach.totalReviews} reviews</p>

            <Link
              href={`/booking/${coach.id}`}
              className="btn-primary w-full text-center block py-3 text-base"
            >
              Book a Session
            </Link>

            <p className="text-xs text-center text-gray-400 mt-3">
              Free cancellation up to 24 hours before
            </p>

            <hr className="my-4" />
            <ul className="text-sm text-gray-600 space-y-2">
              <li className="flex items-center gap-2">
                <CheckCircle className="w-4 h-4 text-green-500" />
                Verified coach
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-4 h-4 text-green-500" />
                Instant booking confirmation
              </li>
              <li className="flex items-center gap-2">
                <CheckCircle className="w-4 h-4 text-green-500" />
                Secure payment
              </li>
            </ul>
          </div>
        </aside>
      </div>
    </div>
  );
}
