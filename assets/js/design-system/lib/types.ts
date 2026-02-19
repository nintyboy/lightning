/**
 * Base type definitions for the design system
 */

/**
 * Semantic color variants for components
 */
export type VariantColor =
  | 'gray'
  | 'red'
  | 'yellow'
  | 'green'
  | 'blue'
  | 'indigo';

/**
 * Size variants for components
 */
export type Size = 'sm' | 'md' | 'lg';

/**
 * Base props for all components
 */
export interface BaseProps {
  className?: string;
}
