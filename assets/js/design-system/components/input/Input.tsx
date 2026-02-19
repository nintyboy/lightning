/**
 * Input Component
 *
 * Base input component with styling that matches the HEEx input element.
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/new_inputs.ex#L1026-L1045
 *
 * Supports all standard HTML input types including text, email, password, number, etc.
 */

import { cn } from '../../lib/cn';

export type InputType =
  | 'text'
  | 'email'
  | 'password'
  | 'number'
  | 'tel'
  | 'url'
  | 'search'
  | 'date'
  | 'datetime-local'
  | 'time'
  | 'color'
  | 'file'
  | 'hidden';

export interface InputProps
  extends Omit<React.ComponentProps<'input'>, 'size'> {
  type?: InputType;
  errors?: string[];
  className?: string;
}

const baseInputClasses =
  'focus:outline focus:outline-2 focus:outline-offset-1 block w-full rounded-lg text-slate-900 focus:ring-0 sm:text-sm sm:leading-6 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500';

const stateClasses = {
  default:
    'phx-no-feedback:border-slate-300 phx-no-feedback:focus:border-slate-400 border-slate-300 focus:border-slate-400 focus:outline-primary-600',
  error: 'border-danger-400 focus:border-danger-400 focus:outline-danger-400',
};

export function Input({
  type = 'text',
  errors = [],
  className,
  ...props
}: InputProps) {
  const hasError = errors.length > 0;

  return (
    <input
      type={type}
      className={cn(
        baseInputClasses,
        hasError ? stateClasses.error : stateClasses.default,
        className
      )}
      {...props}
    />
  );
}
