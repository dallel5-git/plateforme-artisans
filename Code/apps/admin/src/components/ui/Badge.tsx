import React from 'react';
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';
import { Clock, AlertTriangle, CheckCircle2, XCircle, AlertCircle } from 'lucide-react';
import type { VerificationStatus } from '@repo/validators';

export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: 'default' | 'pending' | 'warning' | 'approved' | 'rejected' | 'outline' | 'danger';
  size?: 'sm' | 'md';
}

export const Badge: React.FC<BadgeProps> = ({
  className,
  variant = 'default',
  size = 'md',
  children,
  ...props
}) => {
  const base = 'inline-flex items-center font-medium rounded-full shrink-0 select-none';

  const variants = {
    default: 'bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300',
    pending:
      'bg-orange-50 text-orange-700 border border-orange-200 dark:bg-orange-950/60 dark:text-orange-300 dark:border-orange-800',
    warning:
      'bg-amber-50 text-amber-800 border border-amber-200 dark:bg-amber-950/60 dark:text-amber-300 dark:border-amber-800',
    approved:
      'bg-emerald-50 text-emerald-700 border border-emerald-200 dark:bg-emerald-950/60 dark:text-emerald-300 dark:border-emerald-800',
    rejected:
      'bg-red-50 text-red-700 border border-red-200 dark:bg-red-950/60 dark:text-red-300 dark:border-red-800',
    danger: 'bg-red-600 text-white font-semibold shadow-sm',
    outline: 'border border-slate-300 text-slate-600 dark:border-slate-700 dark:text-slate-400',
  };

  const sizes = {
    sm: 'text-xs px-2 py-0.5 gap-1',
    md: 'text-xs px-2.5 py-1 gap-1.5',
  };

  return (
    <span className={twMerge(clsx(base, variants[variant], sizes[size], className))} {...props}>
      {children}
    </span>
  );
};

export const VerificationStatusBadge: React.FC<{
  status: VerificationStatus;
  className?: string;
}> = ({ status, className }) => {
  switch (status) {
    case 'PENDING':
      return (
        <Badge variant="pending" className={className}>
          <Clock className="w-3.5 h-3.5 text-orange-600" />
          <span>En attente</span>
        </Badge>
      );
    case 'MORE_INFO_REQUIRED':
      return (
        <Badge variant="warning" className={className}>
          <AlertCircle className="w-3.5 h-3.5 text-amber-600" />
          <span>Complément requis</span>
        </Badge>
      );
    case 'APPROVED':
      return (
        <Badge variant="approved" className={className}>
          <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
          <span>Validé</span>
        </Badge>
      );
    case 'REJECTED':
      return (
        <Badge variant="rejected" className={className}>
          <XCircle className="w-3.5 h-3.5 text-red-600" />
          <span>Rejeté</span>
        </Badge>
      );
    default:
      return (
        <Badge variant="default" className={className}>
          <span>{status}</span>
        </Badge>
      );
  }
};

export const OverdueBadge: React.FC<{
  submittedAt: Date | string;
  className?: string;
}> = ({ submittedAt, className }) => {
  const date = typeof submittedAt === 'string' ? new Date(submittedAt) : submittedAt;
  const now = new Date();
  const diffHours = (now.getTime() - date.getTime()) / (1000 * 60 * 60);

  if (diffHours < 48) {
    return null;
  }

  return (
    <Badge variant="danger" size="sm" className={twMerge('animate-pulse', className)}>
      <AlertTriangle className="w-3 h-3 text-white" />
      <span>&gt; 48h (Urgent)</span>
    </Badge>
  );
};
