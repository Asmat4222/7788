'use client';

import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import { format } from 'date-fns';
import toast from 'react-hot-toast';
import { Users, Calendar, CheckCircle, XCircle, Shield } from 'lucide-react';

export default function AdminDashboard() {
  const { data: session, status } = useSession();
  const router = useRouter();
  const [data, setData] = useState({ coaches: [], users: [], bookings: [] });
  const [tab, setTab] = useState('pending');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (status === 'unauthenticated') router.push('/login');
    if (status === 'authenticated' && session?.user?.role !== 'admin') router.push('/');
  }, [status, session]);

  useEffect(() => {
    if (status === 'authenticated' && session?.user?.role === 'admin') {
      fetch('/api/admin/coaches')
        .then((r) => r.json())
        .then((d) => { setData(d); setLoading(false); });
    }
  }, [status, session]);

  const approveCoach = async (coachId, approve) => {
    const res = await fetch(`/api/admin/coaches/${coachId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ approved: approve }),
    });
    if (res.ok) {
      setData((prev) => ({
        ...prev,
        coaches: prev.coaches.map((c) =>
          c.id === coachId ? { ...c, approved: approve } : c
        ),
      }));
      toast.success(approve ? 'Coach approved!' : 'Coach removed');
    }
  };

  if (loading) return <div className="text-center py-20 text-gray-400">Loading...</div>;

  const pendingCoaches = data.coaches.filter((c) => !c.approved);
  const approvedCoaches = data.coaches.filter((c) => c.approved);

  return (
    <div className="max-w-6xl mx-auto px-4 py-10">
      <div className="flex items-center gap-3 mb-8">
        <Shield className="w-8 h-8 text-green-600" />
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Admin Panel</h1>
          <p className="text-gray-500">Platform management</p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        {[
          { label: 'Total Users', value: data.users?.length || 0, icon: Users, color: 'text-blue-600' },
          { label: 'Total Coaches', value: data.coaches.length, icon: CheckCircle, color: 'text-green-600' },
          { label: 'Pending Approval', value: pendingCoaches.length, icon: XCircle, color: 'text-yellow-600' },
          { label: 'Total Bookings', value: data.bookings?.length || 0, icon: Calendar, color: 'text-purple-600' },
        ].map(({ label, value, icon: Icon, color }) => (
          <div key={label} className="card p-4 text-center">
            <Icon className={`w-6 h-6 ${color} mx-auto mb-1`} />
            <div className="text-2xl font-bold text-gray-900">{value}</div>
            <div className="text-sm text-gray-500">{label}</div>
          </div>
        ))}
      </div>

      {/* Tabs */}
      <div className="flex gap-4 border-b mb-6">
        {[
          { key: 'pending', label: `Pending (${pendingCoaches.length})` },
          { key: 'coaches', label: `All Coaches (${approvedCoaches.length})` },
          { key: 'users', label: `Users (${data.users?.length || 0})` },
          { key: 'bookings', label: `Bookings (${data.bookings?.length || 0})` },
        ].map(({ key, label }) => (
          <button
            key={key}
            onClick={() => setTab(key)}
            className={`pb-3 px-1 text-sm font-medium border-b-2 transition-colors ${
              tab === key ? 'border-green-500 text-green-600' : 'border-transparent text-gray-500 hover:text-gray-700'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {/* Pending coaches */}
      {tab === 'pending' && (
        <div className="space-y-3">
          {pendingCoaches.length === 0 ? (
            <div className="card p-12 text-center text-gray-400">
              <CheckCircle className="w-12 h-12 mx-auto mb-2 opacity-30" />
              <p>No pending approvals</p>
            </div>
          ) : (
            pendingCoaches.map((coach) => (
              <div key={coach.id} className="card p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <div className="font-semibold text-gray-900">{coach.user?.name}</div>
                    <div className="text-sm text-gray-500">{coach.user?.email} · {coach.location}</div>
                    <div className="text-sm text-gray-400 mt-1">${coach.hourlyRate}/hr · {coach.experience} yrs exp</div>
                    <p className="text-sm text-gray-600 mt-1 max-w-xl line-clamp-2">{coach.bio}</p>
                  </div>
                  <div className="flex gap-2 ml-4">
                    <button
                      onClick={() => approveCoach(coach.id, true)}
                      className="flex items-center gap-1 bg-green-100 text-green-700 hover:bg-green-200 px-3 py-1.5 rounded-lg text-sm font-medium"
                    >
                      <CheckCircle className="w-3.5 h-3.5" /> Approve
                    </button>
                    <button
                      onClick={() => approveCoach(coach.id, false)}
                      className="flex items-center gap-1 bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1.5 rounded-lg text-sm font-medium"
                    >
                      <XCircle className="w-3.5 h-3.5" /> Reject
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      )}

      {/* All coaches */}
      {tab === 'coaches' && (
        <div className="space-y-2">
          {approvedCoaches.map((coach) => (
            <div key={coach.id} className="card p-4 flex items-center justify-between">
              <div>
                <span className="font-semibold text-gray-900">{coach.user?.name}</span>
                <span className="text-sm text-gray-500 ml-2">{coach.location} · ${coach.hourlyRate}/hr · ⭐ {coach.rating.toFixed(1)}</span>
              </div>
              <button
                onClick={() => approveCoach(coach.id, false)}
                className="text-xs text-red-500 hover:text-red-700 border border-red-200 hover:border-red-400 px-2 py-1 rounded"
              >
                Remove
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Users */}
      {tab === 'users' && (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b text-left text-gray-500">
                <th className="pb-2 pr-4">Name</th>
                <th className="pb-2 pr-4">Email</th>
                <th className="pb-2 pr-4">Role</th>
                <th className="pb-2">Joined</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {data.users?.map((user) => (
                <tr key={user.id}>
                  <td className="py-2 pr-4 font-medium text-gray-900">{user.name}</td>
                  <td className="py-2 pr-4 text-gray-500">{user.email}</td>
                  <td className="py-2 pr-4">
                    <span className={`badge ${
                      user.role === 'admin' ? 'bg-purple-100 text-purple-700' :
                      user.role === 'coach' ? 'bg-green-100 text-green-700' :
                      'bg-gray-100 text-gray-600'
                    }`}>{user.role}</span>
                  </td>
                  <td className="py-2 text-gray-400">{format(new Date(user.createdAt), 'MMM d, yyyy')}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Bookings */}
      {tab === 'bookings' && (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b text-left text-gray-500">
                <th className="pb-2 pr-4">Student</th>
                <th className="pb-2 pr-4">Coach</th>
                <th className="pb-2 pr-4">Date</th>
                <th className="pb-2 pr-4">Status</th>
                <th className="pb-2">Amount</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {data.bookings?.map((b) => (
                <tr key={b.id}>
                  <td className="py-2 pr-4">{b.student?.name}</td>
                  <td className="py-2 pr-4">{b.coach?.user?.name}</td>
                  <td className="py-2 pr-4 text-gray-500">{format(new Date(b.date), 'MMM d, yyyy')}</td>
                  <td className="py-2 pr-4">
                    <span className={`badge text-xs ${
                      b.status === 'confirmed' ? 'bg-green-100 text-green-700' :
                      b.status === 'pending' ? 'bg-yellow-100 text-yellow-700' :
                      b.status === 'cancelled' ? 'bg-red-100 text-red-700' :
                      'bg-blue-100 text-blue-700'
                    }`}>{b.status}</span>
                  </td>
                  <td className="py-2 font-medium text-green-600">${b.totalPrice}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
