import React from 'react';
import { AlertTriangle } from 'lucide-react';
import { Button } from './Button';

export interface ErrorStateProps {
  title?: string;
  message?: string;
  onRetry?: () => void;
  retryLabel?: string;
}

export const ErrorState: React.FC<ErrorStateProps> = ({
  title = 'Une erreur est survenue',
  message = 'Impossible de charger les données pour le moment. Veuillez réessayer.',
  onRetry,
  retryLabel = 'Réessayer',
}) => {
  return (
    <div className="flex flex-col items-center justify-center p-8 text-center bg-red-50/50 dark:bg-red-950/20 rounded-xl border border-red-200 dark:border-red-900 my-4">
      <div className="w-12 h-12 rounded-full bg-red-100 dark:bg-red-900/50 flex items-center justify-center text-red-600 mb-4">
        <AlertTriangle className="w-6 h-6" />
      </div>
      <h3 className="text-base font-semibold text-slate-900 dark:text-white mb-1">
        {title}
      </h3>
      <p className="text-sm text-slate-600 dark:text-slate-400 max-w-sm mb-5">
        {message}
      </p>
      {onRetry && (
        <Button variant="danger" size="sm" onClick={onRetry}>
          {retryLabel}
        </Button>
      )}
    </div>
  );
};
