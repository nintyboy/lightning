import type { ReactNode } from 'react';
import { Button as AriaButton } from 'react-aria-components';
import { cva, cx } from 'class-variance-authority';

// Shared class recipe — the same JSON the HEEx button
// (lib/lightning_web/components/ui/button.ex) reads at compile time.
// Styling changes belong in the recipe, not here.
import recipe from '../../recipes/button.json';

export type ButtonVariant = keyof typeof recipe.variants;
export type ButtonSize = keyof typeof recipe.sizes;

const variantNames = Object.keys(recipe.variants) as ButtonVariant[];

/**
 * CVA definition built from the shared recipe.
 *
 * The enabled/disabled class swap is modeled as a `vstate` dimension with
 * compound variants (rather than `disabled:` pseudo-classes) so that the
 * rendered classes match the HEEx implementation exactly and hover styles
 * can never leak into the disabled state
 * (.claude/guidelines/ui-patterns.md).
 */
export const buttonVariants = cva(recipe.base, {
  variants: {
    variant: Object.fromEntries(variantNames.map(v => [v, ''])) as Record<
      ButtonVariant,
      string
    >,
    size: recipe.sizes,
    vstate: {
      enabled: 'cursor-pointer',
      disabled: 'cursor-not-allowed',
    },
  },
  compoundVariants: variantNames.flatMap(variant => [
    {
      variant,
      vstate: 'enabled' as const,
      class: recipe.variants[variant].enabled,
    },
    {
      variant,
      vstate: 'disabled' as const,
      class: recipe.variants[variant].disabled,
    },
  ]),
  defaultVariants: { variant: 'primary', size: 'md', vstate: 'enabled' },
});

interface ButtonBaseProps {
  /** Recipe variant. `nakedClose` is a deprecated compatibility alias for the
   *  collaborative editor's close affordance; prefer `ghost` + `size="icon"`. */
  variant?: ButtonVariant | 'nakedClose';
  size?: ButtonSize;
  disabled?: boolean;
  /** Disables the button while a related action is in flight. A visual
   *  spinner (and its aria-busy semantics) is deliberately not rendered:
   *  the loading treatment is an open Phase 0 design gate. */
  loading?: boolean;
  onClick?: () => void;
  type?: 'button' | 'submit';
  className?: string;
  id?: string;
  /** Icon rendered before the label. Pass a ReactNode (e.g. a hero-* span). */
  iconLeft?: ReactNode;
  /** Icon rendered after the label. */
  iconRight?: ReactNode;
}

type ButtonWithChildren = ButtonBaseProps & {
  children: ReactNode;
  'aria-label'?: string;
};

/** Icon-only usage: no children ⇒ an accessible name is REQUIRED.
 *  No English default is provided (i18n convention: the app supplies all
 *  user-facing strings). */
type ButtonIconOnly = ButtonBaseProps & {
  children?: undefined;
  'aria-label': string;
};

export type ButtonProps = ButtonWithChildren | ButtonIconOnly;

// nakedClose is a React-local close affordance, kept for compatibility with
// existing collaborative-editor call sites. Not part of the shared recipe.
const nakedCloseClasses = cx(
  'relative rounded-md',
  'focus-visible:outline-2 focus-visible:outline-offset-2',
  'focus-visible:outline-primary-600',
  'disabled:opacity-50 disabled:cursor-not-allowed',
  'text-gray-400 hover:text-gray-500'
);

/**
 * The canonical button (design-system POC), shared-recipe styled and built on
 * react-aria's Button for robust press/keyboard/focus semantics.
 *
 * @example
 * <Button variant="danger" onClick={handleDelete}>Delete</Button>
 * <Button variant="ghost" size="icon" aria-label="Copy" iconLeft={<span className="hero-clipboard size-4" />} />
 */
export function Button({
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  loading = false,
  onClick,
  type = 'button',
  className = '',
  id,
  iconLeft,
  iconRight,
  'aria-label': ariaLabel,
}: ButtonProps) {
  const isDisabled = disabled || loading;

  const classes =
    variant === 'nakedClose'
      ? cx(nakedCloseClasses, className)
      : cx(
          buttonVariants({
            variant,
            size,
            vstate: isDisabled ? 'disabled' : 'enabled',
          }),
          className
        );

  return (
    <AriaButton
      type={type}
      isDisabled={isDisabled}
      className={classes}
      {...(id !== undefined ? { id } : {})}
      {...(ariaLabel !== undefined ? { 'aria-label': ariaLabel } : {})}
      {...(onClick ? { onPress: () => onClick() } : {})}
    >
      {variant === 'nakedClose' ? (
        <>
          <span className="absolute -inset-2.5" />
          <svg
            className="size-6"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.5"
            aria-hidden="true"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M6 18 18 6M6 6l12 12"
            />
          </svg>
        </>
      ) : (
        <>
          {iconLeft ? (
            <span
              className={cx(
                'inline-flex align-middle',
                children != null && 'mr-1.5 -ml-0.5'
              )}
              aria-hidden="true"
            >
              {iconLeft}
            </span>
          ) : null}
          {children}
          {iconRight ? (
            <span
              className={cx(
                'inline-flex align-middle',
                children != null && 'ml-1.5 -mr-0.5'
              )}
              aria-hidden="true"
            >
              {iconRight}
            </span>
          ) : null}
        </>
      )}
    </AriaButton>
  );
}
