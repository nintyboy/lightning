import type { ReactNode } from 'react';

// Shared class recipe — the same JSON the HEEx button
// (lib/lightning_web/components/ui/button.ex) reads at compile time.
// Styling changes belong in the recipe, not here.
import recipe from '../../../packages/ui/recipes/button.json';

interface ButtonProps {
  children?: ReactNode;
  variant?: 'primary' | 'danger' | 'secondary' | 'nakedClose';
  disabled?: boolean;
  loading?: boolean;
  onClick?: () => void;
  type?: 'button' | 'submit';
  className?: string;
  'aria-label'?: string;
}

// nakedClose is a React-local close-affordance, not a recipe variant
// (candidate to fold into a ghost/icon combination later).
const nakedCloseClasses = `
  relative rounded-md
  focus-visible:outline-2 focus-visible:outline-offset-2
  focus-visible:outline-indigo-600
  disabled:opacity-50 disabled:cursor-not-allowed
  text-gray-400 hover:text-gray-500
`;

/**
 * Reusable button component with consistent styling
 * across the collaborative editor.
 *
 * @example
 * <Button variant="danger" onClick={handleDelete}>
 *   Delete
 * </Button>
 */
export function Button({
  children,
  variant = 'primary',
  disabled = false,
  loading = false,
  onClick,
  type = 'button',
  className = '',
  'aria-label': ariaLabel,
}: ButtonProps) {
  const isDisabled = disabled || loading;

  const buttonClasses =
    variant === 'nakedClose'
      ? nakedCloseClasses
      : [
          recipe.base,
          recipe.sizes.md,
          'disabled:cursor-not-allowed',
          isDisabled
            ? recipe.variants[variant].disabled
            : recipe.variants[variant].enabled,
        ].join(' ');

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={isDisabled}
      aria-label={ariaLabel}
      className={`
        ${buttonClasses}
        ${className}
      `
        .replace(/\s+/g, ' ')
        .trim()}
    >
      {variant === 'nakedClose' ? (
        <>
          <span className="absolute -inset-2.5" />
          <span className="sr-only">{ariaLabel || 'Close panel'}</span>
          <div className="hero-x-mark size-6" />
        </>
      ) : (
        children
      )}
    </button>
  );
}
