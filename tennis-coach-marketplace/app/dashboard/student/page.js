'use client';

import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import Link from 'next/link';
import { format } from 'date-fns';
import toast from 'react-hot-toast';
import StarRating from '../../../components/StarRating';
import { Calendar, Clock, X, Star, Search } from 'lucide-react';

const STATUS_COLORS = {
  pending: 'bg-yellow-100 text-yellow-700',
  confirmed: 'bg-green-100 text-green-700',
  cancelled: 'bg-red-100 text-red-700',
  completed: 'bg-blue-100 text-blue-700',
};

export default function StudentDashboard() {
  const { data: session, status } = useSession();
  const router = useRouter();
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [reviewModal, setReviewModal] = useState(null);
  const [reviewForm, setReviewForm] = useState({ rating: 5, comment: '' });

  useEffect(() => {
    if (status === 'unauthenticated') router.push('/login');
    if (status === 'authenticated' && session?.user?.role !== 'student') {
      router.push(`/dashboard/${session.user.role}`);
    }
  }, [status, session]);

  useEffect(() => {
    if (status === 'authenticated') {
      fetch('/api/bookings')
        .then((r) => r.json())
        .then((d) => { setBookings(d); setLoading(false); });
    }
  }, [status]);

  const cancelBooking = async (id) => {
    const res = await fetch(`/api/bookings/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: 'cancelled' }),
    });
    if (res.ok) {
      setBookings(bookings.map((b) => b.id === id ? { ...b, status: 'cancelled' } : b));
      toast.success('Booking cancelled');
    }
  };

  const submitReview = async () => {
    const res = await fetch('/api/reviews', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ...reviewForm, bookingId: reviewModal.id, coachId: reviewModal.coachId }),
    });
    if (res.ok) {
      toast.success('Review submitted!');
      setReviewModal(null);
      setBookings(bookings.map((b) => b.id === reviewModal.id ? { ...b, hasReview: true } : b));
    } else {
      toast.error('Failed to submit review');
    }
  };

  if (loading) return <div className="text-center py-20 text-gray-400">Loading...</div>;

  const upcoming = bookings.filter((b) => ['pending', 'confirmed'].includes(b.status));
  const past = bookings.filter((b) => ['completed', 'cancelled'].includes(b.status));

  return (
    <div className="max-w-5xl mx-auto px-4 py-10">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">My Dashboard</h1>
          <p className="text-gray-500">Welcome back, {session?.user?.name}!</p>
        </div>
        <Link href="/coaches" className="btn-primary flex items-center gap-2 text-sm">
          <Search className="w-4 h-4" /> Find Coaches
        </Link>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-4 mb-8">
        {[
          { label: 'Total Bookings', value: bookings.length },
          { label: 'Upcoming', value: upcoming.length },
          { label: 'Completed', value: bookings.filter((b) => b.status === 'completed').length },
        ].map(({ label, value }) => (
          <div key={label} className="card p-4 text-center">
            <div className="text-3xl font-bold text-green-600">{value}</div>
            <div className="text-sm text-gray-500">{label}</div>
          </div>
        ))}
      </div>

      {/* Upcoming */}
      <section className="mb-8">
        <h2 className="text-lg font-bold text-gray-900 mb-4">Upcoming Sessions</h2>
        {upcoming.length === 0 ? (
          <div className="card p-8 text-center text-gray-400">
            <Calendar className="w-12 h-12 mx-auto mb-2 opacity-30" />
            <p>No upcoming bookings. <Link href="/coaches" className="text-green-600 hover:underline">Find a coach</Link></p>
          </div>
        ) : (
          <div className="space-y-3">
            {upcoming.map((booking) => (
              <BookingCard
                key={booking.id}
                booking={booking}
                onCancel={() => cancelBooking(booking.id)}
                onReview={() => setReviewModal(booking)}
              />
            ))}
          </div>
        )}
      </section>

      {/* Past */}
      {past.length > 0 && (
        <section>
          <h2 className="text-lg font-bold text-gray-900 mb-4">Past Sessions</h2>
          <div className="space-y-3">
            {past.map((booking) => (
              <BookingCard
                key={booking.id}
                booking={booking}
                onReview={() => !booking.review && setReviewModal(booking)}
                showReviewBtn={booking.status === 'completed' && !booking.review}
              />
            ))}
          </div>
        </section>
      )}

      {/* Review Modal */}
      {reviewModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl p-6 max-w-md w-full">
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-bold text-gray-900 text-lg">Leave a Review</h3>
              <button onClick={() => setReviewModal(null)}><X className="w-5 h-5" /></button>
            </div>
            <p className="text-sm text-gray-500 mb-4">Session with {reviewModal.coach?.user?.name}</p>
            <div className="mb-4">
              <label className="text-sm font-medium text-gray-700 mb-2 block">Rating</label>
              <StarRating rating={reviewForm.rating} size="lg" interactive onChange={(r) => setReviewForm({ ...reviewForm, rating: r })} />
            </div>
            <textarea
              value={reviewForm.comment}
              onChange={(e) => setReviewForm({ ...reviewForm, comment: e.target.value })}
              placeholder="Share your experience..."
              rows={4}
              className="w-full border border-gray-200 rounded-lg p-3 text-sm focus:ring-2 focus:ring-green-500 outline-none resize-none mb-4"
            />
            <button onClick={submitReview} className="w-full btn-primary py-2.5">Submit Review</button>
          </div>
        </div>
      )}
    </div>
  );
}

function BookingCard({ booking, onCancel, onReview, showReviewBtn }) {
  return (
    <div className="card p-4 flex items-center gap-4">
      <div className="flex-1">
        <div className="flex items-center gap-2 mb-1">
          <span className="font-semibold text-gray-900">{booking.coach?.user?.name}</span>
          <span className={`badge text-xs ${STATUS_COLORS[booking.status]}`}>{booking.status}</span>
        </div>
        <div className="flex items-center gap-4 text-sm text-gray-500">
          <span className="flex items-center gap-1">
            <Calendar className="w-3.5 h-3.5" />
            {format(new Date(booking.date), 'MMM d, yyyy')}
          </span>
          <span className="flex items-center gap-1">
            <Clock className="w-3.5 h-3.5" />
            {booking.startTime}–{booking.endTime}
          </span>
          <span className="font-medium text-green-600">${booking.totalPrice}</span>
        </div>
      </div>
      <div className="flex gap-2">
        {showReviewBtn && (
          <button onClick={onReview} className="text-sm border border-yellow-400 text-yellow-600 hover:bg-yellow-50 px-3 py-1.5 rounded-lg flex items-center gap-1">
            <Star className="w-3.5 h-3.5" /> Review
          </button>
        )}
        {['pending', 'confirmed'].includes(booking.status) && (
          <button onClick={onCancel} className="text-sm border border-red-200 text-red-500 hover:bg-red-50 px-3 py-1.5 rounded-lg flex items-center gap-1">
            <X className="w-3.5 h-3.5" /> Cancel
          </button>
        )}
      </div>
    </div>
  );
}
