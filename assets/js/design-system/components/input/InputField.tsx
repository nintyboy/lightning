/**
 * InputField Component
 *
 * A wrapper component that combines a label, input, error messages, and help text.
 * Matches the HEEx input field pattern from new_inputs.ex
 *
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/new_inputs.ex#L355-L443
 */

import type { ReactNode } from 'react';
import { Input, type InputProps } from './Input';

export interface InputFieldProps extends Omit<InputProps, 'id'> {
  id?: string;
  label?: string;
  sublabel?: string;
  errors?: string[];
  required?: boolean;
  helpText?: ReactNode;
  children?: ReactNode;
}

export function InputField({
  id,
  label,
  sublabel,
  errors = [],
  required = false,
  helpText,
  children,
  className,
  ...inputProps
}: InputFieldProps) {
  const hasError = errors.length > 0;
  const inputId = id || inputProps.name;

  return (
    <div className={className}>
      {label && (
        <label
          htmlFor={inputId}
          className="mb-2 text-sm/6 font-medium text-slate-800"
        >
          {label}
          {required && <span className="text-red-500 ml-1">*</span>}
        </label>
      )}

      {sublabel && (
        <small className="mb-2 block text-xs text-gray-600">{sublabel}</small>
      )}

      <div className="relative">
        <Input id={inputId} errors={errors} {...inputProps} />
        {children}
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

      {helpText && !hasError && (
        <p className="mt-1 text-xs text-gray-500">{helpText}</p>
      )}
    </div>
  );
}
