/**
 * Select Component
 *
 * Native select component with custom styling that matches the HEEx select.
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/new_inputs.ex#L456-L491
 */

import type { ReactNode } from 'react';
import { cn } from '../../lib/cn';

export interface SelectOption {
  label: string;
  value: string;
  disabled?: boolean;
}

export interface SelectProps
  extends Omit<React.ComponentProps<'select'>, 'size'> {
  options: SelectOption[];
  prompt?: string;
  label?: string;
  errors?: string[];
  required?: boolean;
  buttonPlacement?: 'left' | 'right';
  className?: string;
  children?: ReactNode;
}

const baseSelectClasses =
  'block w-full rounded-lg border border-secondary-300 bg-white sm:text-sm shadow-xs focus:border-primary-300 focus:ring focus:ring-primary-200/50 disabled:cursor-not-allowed';

export function Select({
  options,
  prompt,
  label,
  errors = [],
  required = false,
  buttonPlacement,
  className,
  children,
  ...props
}: SelectProps) {
  return (
    <div>
      {label && (
        <label
          htmlFor={props.id}
          className="mb-2 text-sm/6 font-medium text-slate-800"
        >
          {label}
          {required && <span className="text-red-500 ml-1">*</span>}
        </label>
      )}

      <div className="flex w-full">
        <div className="relative items-center w-full">
          <select
            className={cn(
              baseSelectClasses,
              buttonPlacement === 'right' && 'rounded-r-none',
              buttonPlacement === 'left' && 'rounded-l-none',
              className
            )}
            {...props}
          >
            {prompt && <option value="">{prompt}</option>}
            {options.map(option => (
              <option
                key={option.value}
                value={option.value}
                disabled={option.disabled}
              >
                {option.label}
              </option>
            ))}
          </select>
        </div>
        <div className="relative rounded-l-none">{children}</div>
      </div>

      {errors.length > 0 && (
        <div className="mt-1 space-y-0.5">
          {errors.map((error, index) => (
            <p
              key={index}
              data-tag="error_message"
              className="inline-flex items-center gap-x-1.5 text-xs text-danger-600"
            >
              <span className="hero-exclamation-circle h-4 w-4" />
              {error}
            </p>
          ))}
        </div>
      )}
    </div>
  );
}
