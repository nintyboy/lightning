/**
 * Toast Component
 *
 * Extends the existing Sonner toast library with typed variants.
 * Sonner is already installed in the project (package.json#L55)
 *
 * Usage:
 * ```tsx
 * import { toast } from '@/design-system/components/toast';
 *
 * toast.success('Changes saved successfully');
 * toast.error('Failed to save changes');
 * ```
 */

import { toast as sonnerToast } from 'sonner';

export type ToastVariant = 'info' | 'success' | 'warning' | 'error';

export interface ToastOptions {
  duration?: number;
  id?: string;
  dismissible?: boolean;
}

/**
 * Toast API that wraps Sonner with typed variants
 */
export const toast = {
  success: (message: string, options?: ToastOptions) => {
    return sonnerToast.success(message, options);
  },

  error: (message: string, options?: ToastOptions) => {
    return sonnerToast.error(message, options);
  },

  info: (message: string, options?: ToastOptions) => {
    return sonnerToast.info(message, options);
  },

  warning: (message: string, options?: ToastOptions) => {
    return sonnerToast.warning(message, options);
  },

  dismiss: (id?: string) => {
    return sonnerToast.dismiss(id);
  },

  promise: <T,>(
    promise: Promise<T>,
    {
      loading,
      success,
      error,
    }: {
      loading: string;
      success: string | ((data: T) => string);
      error: string | ((error: unknown) => string);
    }
  ) => {
    return sonnerToast.promise(promise, {
      loading,
      success,
      error,
    });
  },
};

/**
 * Toaster component - should be placed in your app root
 * Re-exports Sonner's Toaster component
 */
export { Toaster } from 'sonner';
