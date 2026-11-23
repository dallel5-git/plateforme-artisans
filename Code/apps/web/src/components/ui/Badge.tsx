import React from 'react';
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';
import { CheckCircle2, Zap } from 'lucide-react';

export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: 'default' | 'verified' | 'emergency' | 'warning' | 'outline';
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
    default: 'bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300',
    verified:
      'bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800',
    emergency:
      'bg-amber-50 dark:bg-amber-950/60 text-amber-800 dark:text-amber-300 border border-amber-200 dark:border-amber-800',
    warning:
      'bg-orange-50 dark:bg-orange-950/60 text-orange-700 dark:text-orange-300 border border-orange-200',
    outline: 'border border-slate-300 dark:border-slate-700 text-slate-600 dark:text-slate-400',
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

export const VerifiedBadge: React.FC<{
  label?: string;
  className?: string;
}> = ({ label = 'Vérifié Sanaya', className }) => {
  return (
    <Badge variant="verified" className={className}>
      <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
      <span>{label}</span>
    </Badge>
  );
};

export const EmergencyBadge: React.FC<{
  label?: string;
  className?: string;
}> = ({ label = 'Urgence 24/7', className }) => {
  return (
    <Badge variant="emergency" className={className}>
      <Zap className="w-3.5 h-3.5 text-amber-600 fill-amber-500" />
      <span>{label}</span>
    </Badge>
  );
};
