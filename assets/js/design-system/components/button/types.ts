/**
 * Button component type definitions
 */

import type { ReactNode } from 'react';

export type ButtonVariant =
  | 'primary'
  | 'secondary'
  | 'danger'
  | 'success'
  | 'warning'
  | 'custom';

export type ButtonSize = 'sm' | 'md' | 'lg';

export interface ButtonProps {
  variant?: ButtonVariant;
  size?: ButtonSize;
  tooltip?: string;
  disabled?: boolean;
  type?: 'button' | 'submit';
  className?: string;
  children: ReactNode;
  onClick?: () => void;
  'aria-label'?: string;
}
