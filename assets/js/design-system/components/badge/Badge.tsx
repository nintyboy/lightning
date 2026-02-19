/**
 * Badge Component
 *
 * A small label or status indicator component.
 * Matches the design system color tokens from app.css
 *
 * Color variants based on semantic color tokens:
 * - gray: neutral/default state
 * - red: danger/error state
 * - yellow: warning state
 * - green: success state
 * - blue: info state
 * - indigo: primary/brand state
 */

import type { ReactNode } from 'react';

import { cn } from '../../lib/cn';

export type BadgeVariant =
  | 'gray'
  | 'red'
  | 'yellow'
  | 'green'
  | 'blue'
  | 'indigo';

export interface BadgeProps {
  variant?: BadgeVariant;
  onClose?: () => void;
  className?: string;
  children: ReactNode;
}

const badgeVariants: Record<
  BadgeVariant,
  { bg: string; text: string; hover: string }
> = {
  gray: {
    bg: 'bg-gray-100',
    text: 'text-gray-700',
    hover: 'hover:bg-gray-200',
  },
  red: {
    bg: 'bg-red-100',
    text: 'text-red-700',
    hover: 'hover:bg-red-200',
  },
  yellow: {
    bg: 'bg-yellow-100',
    text: 'text-yellow-800',
    hover: 'hover:bg-yellow-200',
  },
  green: {
    bg: 'bg-green-100',
    text: 'text-green-700',
    hover: 'hover:bg-green-200',
  },
  blue: {
    bg: 'bg-blue-100',
    text: 'text-blue-700',
    hover: 'hover:bg-blue-200',
  },
  indigo: {
    bg: 'bg-indigo-100',
    text: 'text-indigo-700',
    hover: 'hover:bg-indigo-200',
  },
};

export function Badge({
  variant = 'gray',
  onClose,
  className,
  children,
}: BadgeProps) {
  const classes = badgeVariants[variant];

  return (
    <div
      className={cn(
        'inline-flex items-center gap-x-1',
        'rounded-md px-2 py-1 text-xs font-medium',
        classes.bg,
        classes.text,
        onClose && 'pr-1',
        className
      )}
    >
      <span className="flex items-center">{children}</span>
      {onClose && (
        <button
          onClick={onClose}
          className={cn(
            'group relative -mr-1 flex items-center justify-center h-3.5 w-3.5 rounded-sm',
            classes.hover
          )}
          aria-label="Remove"
          title="Remove"
          type="button"
        >
          <span className="sr-only">Remove</span>
          <span className="hero-x-mark h-3.5 w-3.5" />
        </button>
      )}
    </div>
  );
}
