import StarRating from './StarRating';
import { format } from 'date-fns';

export default function ReviewCard({ review }) {
  return (
    <div className="border-b border-gray-100 pb-4 last:border-0">
      <div className="flex items-start gap-3">
        <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center text-green-700 font-bold text-sm flex-shrink-0">
          {review.user?.name?.charAt(0) || 'U'}
        </div>
        <div className="flex-1">
          <div className="flex items-center justify-between">
            <span className="font-semibold text-gray-900">{review.user?.name}</span>
            <span className="text-sm text-gray-400">
              {format(new Date(review.createdAt), 'MMM d, yyyy')}
            </span>
          </div>
          <StarRating rating={review.rating} />
          <p className="mt-1 text-gray-600 text-sm">{review.comment}</p>
        </div>
      </div>
    </div>
  );
}
