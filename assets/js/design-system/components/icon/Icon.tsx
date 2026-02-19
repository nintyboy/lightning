/**
 * Icon Component
 *
 * Wrapper for Heroicons using the existing hero-* class pattern.
 *
 * The project uses heroicons via Tailwind CSS classes (e.g., "hero-check-micro").
 * This component provides a consistent way to render icons with proper sizing.
 *
 * Usage:
 * ```tsx
 * <Icon name="hero-check-micro" className="h-4 w-4" />
 * <Icon name="hero-exclamation-circle" size="md" />
 * ```
 */

import { cn } from '../../lib/cn';

export type IconSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

export interface IconProps {
  name: string;
  size?: IconSize;
  className?: string;
}

const sizeClasses: Record<IconSize, string> = {
  xs: 'h-3 w-3',
  sm: 'h-4 w-4',
  md: 'h-5 w-5',
  lg: 'h-6 w-6',
  xl: 'h-8 w-8',
};

export function Icon({ name, size = 'md', className }: IconProps) {
  return (
    <span
      className={cn(sizeClasses[size], name, className)}
      aria-hidden="true"
    />
  );
}
