/**
 * Shared variant utilities and class mappings
 * Based on /lib/lightning_web/components/new_inputs.ex
 */

/**
 * Button variant class mappings
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/new_inputs.ex#L229-L263
 */
export const buttonVariants = {
  primary: {
    enabled:
      'bg-primary-600 hover:bg-primary-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-600',
    disabled: 'bg-primary-300 text-white cursor-not-allowed',
  },
  secondary: {
    enabled:
      'bg-white hover:bg-gray-50 text-gray-900 ring-1 ring-gray-300 ring-inset',
    disabled:
      'bg-gray-50 text-gray-400 ring-1 ring-gray-200 ring-inset cursor-not-allowed',
  },
  danger: {
    enabled:
      'bg-red-600 hover:bg-red-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-600',
    disabled: 'bg-red-300 text-white cursor-not-allowed',
  },
  success: {
    enabled:
      'bg-green-600 hover:bg-green-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-600',
    disabled: 'bg-green-300 text-white cursor-not-allowed',
  },
  warning: {
    enabled:
      'bg-yellow-600 hover:bg-yellow-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-yellow-600',
    disabled: 'bg-yellow-300 text-white cursor-not-allowed',
  },
  custom: {
    enabled: '',
    disabled: '',
  },
} as const;

export type ButtonVariant = keyof typeof buttonVariants;

/**
 * Button size class mappings
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/new_inputs.ex#L225-L227
 */
export const buttonSizes = {
  sm: 'px-2.5 py-1.5',
  md: 'px-3 py-2',
  lg: 'px-3.5 py-2.5',
} as const;

export type ButtonSize = keyof typeof buttonSizes;

/**
 * Base button classes
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/new_inputs.ex#L221-L223
 */
export const buttonBaseClasses =
  'rounded-md text-lg font-semibold shadow-xs phx-submit-loading:opacity-75 font-sans';
