/**
 * Button Component
 *
 * A reusable button component with consistent styling across the application.
 * Matches the HEEx button component from new_inputs.ex
 *
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/new_inputs.ex#L110-L150
 */

import { cn } from '../../lib/cn';
import {
  buttonBaseClasses,
  buttonSizes,
  buttonVariants,
} from '../../lib/variants';

import type { ButtonProps } from './types';

export function Button({
  variant = 'primary',
  size = 'md',
  tooltip,
  disabled = false,
  type = 'button',
  className,
  children,
  onClick,
  'aria-label': ariaLabel,
}: ButtonProps) {
  const variantClasses = disabled
    ? buttonVariants[variant].disabled
    : buttonVariants[variant].enabled;

  return (
    <button
      type={type}
      disabled={disabled}
      onClick={onClick}
      aria-label={tooltip || ariaLabel}
      className={cn(
        buttonBaseClasses,
        buttonSizes[size],
        variantClasses,
        'cursor-pointer',
        disabled && 'cursor-auto',
        className
      )}
    >
      {children}
    </button>
  );
}
