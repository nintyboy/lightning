import type { ReactNode } from 'react';
import {
  Button as AriaButton,
  Menu,
  MenuItem,
  MenuTrigger,
  Popover,
} from 'react-aria-components';
import { cx } from 'class-variance-authority';

import {
  Button,
  buttonVariants,
  type ButtonSize,
  type ButtonVariant,
} from './Button';

export interface SplitButtonItem {
  id: string;
  label: ReactNode;
  onAction?: () => void;
  isDisabled?: boolean;
}

export interface SplitButtonProps {
  /** Primary action label. */
  children: ReactNode;
  /** Fired when the primary segment is pressed. */
  onClick?: () => void;
  /** Accessible name for the menu trigger segment — REQUIRED, no English
   *  default (i18n convention: the app supplies all user-facing strings). */
  menuLabel: string;
  items: SplitButtonItem[];
  variant?: Exclude<ButtonVariant, 'custom'>;
  size?: ButtonSize;
  disabled?: boolean;
  type?: 'button' | 'submit';
  className?: string;
  id?: string;
}

/**
 * Split button: a primary action plus an attached menu of related actions.
 * Consolidation target for the three bespoke split buttons found in the
 * inventory (collab SaveButton, RunRetryButton, HEEx new_credential_menu_button).
 *
 * Built on react-aria MenuTrigger for focus/keyboard/dismiss semantics.
 */
export function SplitButton({
  children,
  onClick,
  menuLabel,
  items,
  variant = 'primary',
  size = 'md',
  disabled = false,
  type = 'button',
  className = '',
  id,
}: SplitButtonProps) {
  return (
    <div id={id} className={cx('inline-flex', className)}>
      <Button
        variant={variant}
        size={size}
        disabled={disabled}
        type={type}
        className="rounded-r-none focus-visible:z-10"
        {...(onClick ? { onClick } : {})}
      >
        {children}
      </Button>
      <MenuTrigger>
        <AriaButton
          aria-label={menuLabel}
          isDisabled={disabled}
          className={cx(
            buttonVariants({
              variant,
              size,
              vstate: disabled ? 'disabled' : 'enabled',
            }),
            'rounded-l-none -ml-px px-1.5 focus-visible:z-10'
          )}
        >
          <svg
            className="size-4"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path
              fillRule="evenodd"
              d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z"
              clipRule="evenodd"
            />
          </svg>
        </AriaButton>
        <Popover
          placement="bottom end"
          className="min-w-[10rem] rounded-md bg-white py-1 shadow-lg ring-1 ring-black/5 entering:animate-in exiting:animate-out"
        >
          <Menu className="outline-none text-sm text-gray-700">
            {items.map(item => (
              <MenuItem
                key={item.id}
                id={item.id}
                isDisabled={item.isDisabled ?? false}
                {...(item.onAction ? { onAction: item.onAction } : {})}
                className="cursor-pointer px-4 py-2 outline-none data-[focused]:bg-gray-100 data-[disabled]:cursor-not-allowed data-[disabled]:opacity-50"
              >
                {item.label}
              </MenuItem>
            ))}
          </Menu>
        </Popover>
      </MenuTrigger>
    </div>
  );
}
