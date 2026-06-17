'use client';

import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import { format } from 'date-fns';
import toast from 'react-hot-toast';
import { Calendar, DollarSign, Users, Star, Check, X } from 'lucide-react';

const STATUS_COLORS = {
  pending: 'bg-yellow-100 text-yellow-700',
  confirmed: 'bg-green-100 text-green-700',
  cancelled: 'bg-red-100 text-red-700',
  completed: 'bg-blue-100 text-blue-700',
};

export default function CoachDashboard() {
  const { data: session, status } = useSession();
  const router = useRouter();
  const [bookings, setBookings] = useState([]);
  const [profile, setProfile] = useState(null);
  const [tab, setTab] = useState('bookings');
  const [loading, setLoading] = useState(true);
  const [editForm, setEditForm] = useState(null);

  useEffect(() => {
    if (status === 'unauthenticated') router.push('/login');
  }, [status]);

  useEffect(() => {
    if (status === 'authenticated') {
      Promise.all([
        fetch('/api/bookings').then((r) => r.json()),
        fetch('/api/coaches/me').then((r) => r.json()),
      ]).then(([b, p]) => {
        setBookings(b);
        setProfile(p);
        if (p && !p.error) {
          setEditForm({
            bio: p.bio,
            location: p.location,
            hourlyRate: p.hourlyRate,
            experience: p.experience,
          });
        }
        setLoading(false);
      });
    }
  }, [status]);

  const updateBookingStatus = async (id, newStatus) => {
    const res = await fetch(`/api/bookings/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: newStatus }),
    });
    if (res.ok) {
      setBookings(bookings.map((b) => b.id === id ? { ...b, status: newStatus } : b));
      toast.success(`Booking ${newStatus}`);
    }
  };

  const updateProfile = async (e) => {
    e.preventDefault();
    const res = await fetch('/api/coaches/me', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(editForm),
    });
    if (res.ok) toast.success('Profile updated!');
    else toast.error('Update failed');
  };

  if (loading) return <div className="text-center py-20 text-gray-400">Loading...</div>;

  const earnings = bookings
    .filter((b) => ['confirmed', 'completed'].includes(b.status))
    .reduce((sum, b) => sum + b.totalPrice, 0);

  const pending = bookings.filter((b) => b.status === 'pending');

  return (
    <div className="max-w-5xl mx-auto px-4 py-10">
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900">Coach Dashboard</h1>
        <p className="text-gray-500">{session?.user?.name}</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        {[
          { icon: Calendar, label: 'Total Bookings', value: bookings.length, color: 'text-blue-600' },
          { icon: Users, label: 'Pending', value: pending.length, color: 'text-yellow-600' },
          { icon: DollarSign, label: 'Earnings', value: `$${earnings}`, color: 'text-green-600' },
          { icon: Star, label: 'Rating', value: profile?.rating?.toFixed(1) || '—', color: 'text-yellow-500' },
        ].map(({ icon: Icon, label, value, color }) => (
          <div key={label} className="card p-4 text-center">
            <Icon className={`w-6 h-6 ${color} mx-auto mb-1`} />
            <div className="text-2xl font-bold text-gray-900">{value}</div>
            <div className="text-sm text-gray-500">{label}</div>
          </div>
        ))}
      </div>

      {/* Tabs */}
      <div className="flex gap-4 border-b mb-6">
        {['bookings', 'profile'].map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`pb-3 px-1 text-sm font-medium capitalize border-b-2 transition-colors ${
              tab === t ? 'border-green-500 text-green-600' : 'border-transparent text-gray-500 hover:text-gray-700'
            }`}
          >
            {t}
          </button>
        ))}
      </div>

      {tab === 'bookings' && (
        <div className="space-y-3">
          {bookings.length === 0 ? (
            <div className="card p-12 text-center text-gray-400">
              <Calendar className="w-12 h-12 mx-auto mb-2 opacity-30" />
              <p>No bookings yet</p>
            </div>
          ) : (
            bookings.map((booking) => (
              <div key={booking.id} className="card p-4">
                <div className="flex items-center gap-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <span className="font-semibold text-gray-900">{booking.student?.name}</span>
                      <span className={`badge text-xs ${STATUS_COLORS[booking.status]}`}>{booking.status}</span>
                    </div>
                    <div className="text-sm text-gray-500">
                      {format(new Date(booking.date), 'MMM d, yyyy')} · {booking.startTime}–{booking.endTime} · ${booking.totalPrice}
                    </div>
                    {booking.notes && (
                      <p className="text-sm text-gray-400 mt-1 italic">&ldquo;{booking.notes}&rdquo;</p>
                    )}
                  </div>
                  {booking.status === 'pending' && (
                    <div className="flex gap-2">
                      <button
                        onClick={() => updateBookingStatus(booking.id, 'confirmed')}
                        className="flex items-center gap-1 bg-green-100 text-green-700 hover:bg-green-200 px-3 py-1.5 rounded-lg text-sm font-medium"
                      >
                        <Check className="w-3.5 h-3.5" /> Accept
                      </button>
                      <button
                        onClick={() => updateBookingStatus(booking.id, 'cancelled')}
                        className="flex items-center gap-1 bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg text-sm font-medium"
                      >
                        <X className="w-3.5 h-3.5" /> Decline
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ))
          )}
        </div>
      )}

      {tab === 'profile' && profile && editForm && (
        <form onSubmit={updateProfile} className="card p-6 space-y-4 max-w-lg">
          <h2 className="font-bold text-gray-900 mb-2">Edit Profile</h2>
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Bio</label>
            <textarea
              value={editForm.bio}
              onChange={(e) => setEditForm({ ...editForm, bio: e.target.value })}
              rows={4}
              className="w-full border border-gray-200 rounded-lg p-3 text-sm focus:ring-2 focus:ring-green-500 outline-none resize-none"
            />
          </div>
          <div>
            <label className="text-sm font-medium text-gray-700 mb-1 block">Location</label>
            <input
              value={editForm.location}
              onChange={(e) => setEditForm({ ...editForm, location: e.target.value })}
              className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-green-500 outline-none"
            />
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="text-sm font-medium text-gray-700 mb-1 block">Hourly Rate ($)</label>
              <input
                type="number"
                value={editForm.hourlyRate}
                onChange={(e) => setEditForm({ ...editForm, hourlyRate: Number(e.target.value) })}
                className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-green-500 outline-none"
              />
            </div>
            <div>
              <label className="text-sm font-medium text-gray-700 mb-1 block">Experience (yrs)</label>
              <input
                type="number"
                value={editForm.experience}
                onChange={(e) => setEditForm({ ...editForm, experience: Number(e.target.value) })}
                className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-green-500 outline-none"
              />
            </div>
          </div>
          <button type="submit" className="btn-primary px-6 py-2">Save Changes</button>
        </form>
      )}
    </div>
  );
}
