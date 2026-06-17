'use client';

import { useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import Image from 'next/image';
import { format, addDays, startOfDay } from 'date-fns';
import toast from 'react-hot-toast';
import { Calendar, Clock, DollarSign, ArrowLeft } from 'lucide-react';

const TIME_SLOTS = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'];

export default function BookingPage({ params }) {
  const { data: session, status } = useSession();
  const router = useRouter();
  const [coach, setCoach] = useState(null);
  const [selectedDate, setSelectedDate] = useState(null);
  const [selectedTime, setSelectedTime] = useState('');
  const [notes, setNotes] = useState('');
  const [loading, setLoading] = useState(false);
  const [step, setStep] = useState(1); // 1: pick date/time, 2: confirm

  useEffect(() => {
    if (status === 'unauthenticated') router.push('/login');
  }, [status]);

  useEffect(() => {
    fetch(`/api/coaches/${params.coachId}`)
      .then((r) => r.json())
      .then(setCoach);
  }, [params.coachId]);

  const availableDates = Array.from({ length: 14 }, (_, i) => addDays(startOfDay(new Date()), i + 1));

  const handleConfirm = async () => {
    if (!selectedDate || !selectedTime) {
      toast.error('Please select a date and time');
      return;
    }
    setStep(2);
  };

  const handleBook = async () => {
    setLoading(true);
    const endTime = `${String(Number(selectedTime.split(':')[0]) + 1).padStart(2, '0')}:00`;

    const res = await fetch('/api/bookings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        coachId: params.coachId,
        date: selectedDate.toISOString(),
        startTime: selectedTime,
        endTime,
        notes,
        totalPrice: coach.hourlyRate,
      }),
    });

    setLoading(false);

    if (res.ok) {
      toast.success('Booking confirmed!');
      router.push('/dashboard/student');
    } else {
      const d = await res.json();
      toast.error(d.error || 'Booking failed');
    }
  };

  if (!coach) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-20 text-center">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-gray-200 rounded w-3/4 mx-auto" />
          <div className="h-64 bg-gray-200 rounded" />
        </div>
      </div>
    );
  }

  const avatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(coach.user?.name || 'Coach')}&background=16a34a&color=fff&size=200`;

  return (
    <div className="max-w-3xl mx-auto px-4 py-10">
      <Link href={`/coaches/${params.coachId}`} className="flex items-center gap-2 text-gray-500 hover:text-gray-700 mb-6 text-sm">
        <ArrowLeft className="w-4 h-4" />
        Back to profile
      </Link>

      <h1 className="text-2xl font-bold text-gray-900 mb-6">Book a Session</h1>

      {/* Coach summary */}
      <div className="card p-4 flex items-center gap-4 mb-6">
        <Image
          src={coach.profileImage || avatarUrl}
          alt={coach.user?.name}
          width={60}
          height={60}
          className="rounded-full"
        />
        <div>
          <div className="font-bold text-gray-900">{coach.user?.name}</div>
          <div className="text-sm text-gray-500">{coach.location}</div>
        </div>
        <div className="ml-auto text-right">
          <div className="text-2xl font-bold text-green-600">${coach.hourlyRate}</div>
          <div className="text-xs text-gray-400">per hour</div>
        </div>
      </div>

      {step === 1 ? (
        <div className="space-y-6">
          {/* Date selection */}
          <div className="card p-6">
            <h2 className="font-bold text-gray-900 mb-4 flex items-center gap-2">
              <Calendar className="w-5 h-5 text-green-500" />
              Select Date
            </h2>
            <div className="grid grid-cols-4 md:grid-cols-7 gap-2">
              {availableDates.map((date) => {
                const isSelected = selectedDate && format(date, 'yyyy-MM-dd') === format(selectedDate, 'yyyy-MM-dd');
                return (
                  <button
                    key={date.toISOString()}
                    onClick={() => setSelectedDate(date)}
                    className={`p-2 rounded-lg text-center border-2 transition-all ${
                      isSelected
                        ? 'border-green-500 bg-green-50 text-green-700'
                        : 'border-gray-200 hover:border-green-300'
                    }`}
                  >
                    <div className="text-xs text-gray-500">{format(date, 'EEE')}</div>
                    <div className="font-bold text-sm">{format(date, 'd')}</div>
                    <div className="text-xs text-gray-400">{format(date, 'MMM')}</div>
                  </button>
                );
              })}
            </div>
          </div>

          {/* Time selection */}
          <div className="card p-6">
            <h2 className="font-bold text-gray-900 mb-4 flex items-center gap-2">
              <Clock className="w-5 h-5 text-green-500" />
              Select Time
            </h2>
            <div className="grid grid-cols-3 md:grid-cols-5 gap-2">
              {TIME_SLOTS.map((time) => (
                <button
                  key={time}
                  onClick={() => setSelectedTime(time)}
                  className={`py-2 px-3 rounded-lg border-2 text-sm font-medium transition-all ${
                    selectedTime === time
                      ? 'border-green-500 bg-green-50 text-green-700'
                      : 'border-gray-200 hover:border-green-300'
                  }`}
                >
                  {time}
                </button>
              ))}
            </div>
          </div>

          {/* Notes */}
          <div className="card p-6">
            <h2 className="font-bold text-gray-900 mb-3">Notes (optional)</h2>
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Tell the coach about your skill level, goals, or specific areas you want to work on..."
              rows={3}
              className="w-full border border-gray-200 rounded-lg p-3 text-sm focus:ring-2 focus:ring-green-500 outline-none resize-none"
            />
          </div>

          <button
            onClick={handleConfirm}
            disabled={!selectedDate || !selectedTime}
            className="w-full btn-primary py-3 text-base disabled:opacity-50"
          >
            Continue to Confirmation
          </button>
        </div>
      ) : (
        /* Step 2: Confirmation */
        <div className="space-y-4">
          <div className="card p-6">
            <h2 className="font-bold text-gray-900 mb-4">Booking Summary</h2>
            <div className="space-y-3 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-500">Coach</span>
                <span className="font-medium">{coach.user?.name}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-500">Date</span>
                <span className="font-medium">{format(selectedDate, 'MMMM d, yyyy')}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-500">Time</span>
                <span className="font-medium">{selectedTime} – {`${String(Number(selectedTime.split(':')[0]) + 1).padStart(2, '0')}:00`}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-500">Duration</span>
                <span className="font-medium">1 hour</span>
              </div>
              <hr />
              <div className="flex justify-between text-base font-bold">
                <span>Total</span>
                <span className="text-green-600">${coach.hourlyRate}</span>
              </div>
            </div>
          </div>

          <div className="card p-4 bg-yellow-50 border-yellow-200">
            <p className="text-sm text-yellow-800">
              💳 <strong>Demo mode:</strong> Payment is simulated. No real charge will be made.
            </p>
          </div>

          <div className="flex gap-3">
            <button
              onClick={() => setStep(1)}
              className="flex-1 btn-secondary py-3"
            >
              Back
            </button>
            <button
              onClick={handleBook}
              disabled={loading}
              className="flex-1 btn-primary py-3 disabled:opacity-60"
            >
              {loading ? 'Confirming...' : `Confirm & Pay $${coach.hourlyRate}`}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
