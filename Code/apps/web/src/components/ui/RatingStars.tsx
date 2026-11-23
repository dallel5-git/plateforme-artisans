import React from 'react';
import { Star } from 'lucide-react';
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export interface RatingStarsProps {
  rating: number;
  count?: number;
  size?: 'sm' | 'md' | 'lg' | number;
  className?: string;
  showText?: boolean;
}

export const RatingStars: React.FC<RatingStarsProps> = ({
  rating,
  count,
  size = 'md',
  className,
  showText = true,
}) => {
  const iconClasses =
    typeof size === 'string'
      ? {
          sm: 'w-3.5 h-3.5',
          md: 'w-4 h-4',
          lg: 'w-5 h-5',
        }[size]
      : '';

  const iconStyle = typeof size === 'number' ? { width: size, height: size } : undefined;

  const textSizes = {
    sm: 'text-xs',
    md: 'text-sm',
    lg: 'text-base font-semibold',
  };

  const clampedRating = Math.max(0, Math.min(5, rating));
  const fullStars = Math.floor(clampedRating);
  const hasHalfStar = clampedRating - fullStars >= 0.5;

  return (
    <div className={twMerge(clsx('inline-flex items-center gap-1.5 select-none', className))}>
      <div className="flex items-center gap-0.5">
        {[1, 2, 3, 4, 5].map((index) => {
          const isFull = index <= fullStars;
          const isHalf = index === fullStars + 1 && hasHalfStar;

          return (
            <div key={index} className="relative inline-block">
              <Star
                className={clsx(
                  iconClasses,
                  'text-slate-300 dark:text-slate-600 transition-colors',
                )}
                style={iconStyle}
              />
              {(isFull || isHalf) && (
                <div
                  className="absolute inset-0 overflow-hidden"
                  style={{ width: isHalf ? '50%' : '100%' }}
                >
                  <Star
                    className={clsx(iconClasses, 'text-amber-400 fill-amber-400 transition-colors')}
                    style={iconStyle}
                  />
                </div>
              )}
            </div>
          );
        })}
      </div>

      {showText && (
        <span
          className={clsx(
            'text-slate-700 dark:text-slate-200 font-medium tabular-nums',
            typeof size === 'string' ? textSizes[size] : 'text-xs',
          )}
        >
          {clampedRating.toFixed(1)}
          {count !== undefined && (
            <span className="text-slate-400 dark:text-slate-500 ms-1 text-xs">({count})</span>
          )}
        </span>
      )}
    </div>
  );
};
