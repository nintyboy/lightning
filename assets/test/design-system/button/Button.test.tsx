/**
 * Button Component Unit Tests
 *
 * Tests for the Button component from the design system.
 * Focuses on variant, size, and state rendering.
 */

import { render, screen } from '@testing-library/react';
import { describe, expect, test, vi } from 'vitest';

import { Button } from '#/design-system/components/button';

// =============================================================================
// TEST HELPERS
// =============================================================================

function renderButton(props: React.ComponentProps<typeof Button>) {
  return render(<Button {...props} />);
}

// =============================================================================
// VARIANT TESTS
// =============================================================================

describe('Button - Variants', () => {
  test('renders primary variant by default', () => {
    renderButton({ children: 'Primary' });

    const button = screen.getByRole('button', { name: 'Primary' });
    expect(button).toBeInTheDocument();
    expect(button).toHaveClass('bg-primary-600', 'text-white');
  });

  test('renders secondary variant correctly', () => {
    renderButton({ variant: 'secondary', children: 'Secondary' });

    const button = screen.getByRole('button', { name: 'Secondary' });
    expect(button).toHaveClass('bg-white', 'text-gray-900', 'ring-1');
  });

  test('renders danger variant correctly', () => {
    renderButton({ variant: 'danger', children: 'Delete' });

    const button = screen.getByRole('button', { name: 'Delete' });
    expect(button).toHaveClass('bg-red-600', 'text-white');
  });

  test('renders success variant correctly', () => {
    renderButton({ variant: 'success', children: 'Success' });

    const button = screen.getByRole('button', { name: 'Success' });
    expect(button).toHaveClass('bg-green-600', 'text-white');
  });

  test('renders warning variant correctly', () => {
    renderButton({ variant: 'warning', children: 'Warning' });

    const button = screen.getByRole('button', { name: 'Warning' });
    expect(button).toHaveClass('bg-yellow-600', 'text-white');
  });

  test('renders custom variant without default styles', () => {
    renderButton({
      variant: 'custom',
      className: 'bg-purple-500',
      children: 'Custom',
    });

    const button = screen.getByRole('button', { name: 'Custom' });
    expect(button).toHaveClass('bg-purple-500');
    expect(button).not.toHaveClass('bg-primary-600', 'bg-white');
  });
});

// =============================================================================
// SIZE TESTS
// =============================================================================

describe('Button - Sizes', () => {
  test('renders medium size by default', () => {
    renderButton({ children: 'Medium' });

    const button = screen.getByRole('button', { name: 'Medium' });
    expect(button).toHaveClass('px-3', 'py-2');
  });

  test('renders small size correctly', () => {
    renderButton({ size: 'sm', children: 'Small' });

    const button = screen.getByRole('button', { name: 'Small' });
    expect(button).toHaveClass('px-2.5', 'py-1.5');
  });

  test('renders large size correctly', () => {
    renderButton({ size: 'lg', children: 'Large' });

    const button = screen.getByRole('button', { name: 'Large' });
    expect(button).toHaveClass('px-3.5', 'py-2.5');
  });
});

// =============================================================================
// STATE TESTS
// =============================================================================

describe('Button - States', () => {
  test('renders enabled state by default', () => {
    renderButton({ children: 'Click me' });

    const button = screen.getByRole('button', { name: 'Click me' });
    expect(button).not.toBeDisabled();
    expect(button).toHaveClass('cursor-pointer');
  });

  test('renders disabled state correctly', () => {
    renderButton({ disabled: true, children: 'Disabled' });

    const button = screen.getByRole('button', { name: 'Disabled' });
    expect(button).toBeDisabled();
    expect(button).toHaveClass('cursor-auto');
  });

  test('shows disabled color for primary variant when disabled', () => {
    renderButton({
      variant: 'primary',
      disabled: true,
      children: 'Primary Disabled',
    });

    const button = screen.getByRole('button', { name: 'Primary Disabled' });
    expect(button).toHaveClass('bg-primary-300', 'cursor-auto');
  });

  test('shows disabled color for danger variant when disabled', () => {
    renderButton({
      variant: 'danger',
      disabled: true,
      children: 'Danger Disabled',
    });

    const button = screen.getByRole('button', { name: 'Danger Disabled' });
    expect(button).toHaveClass('bg-red-300', 'cursor-auto');
  });
});

// =============================================================================
// ATTRIBUTE TESTS
// =============================================================================

describe('Button - Attributes', () => {
  test('renders with custom className', () => {
    renderButton({ className: 'custom-class', children: 'Custom' });

    const button = screen.getByRole('button', { name: 'Custom' });
    expect(button).toHaveClass('custom-class');
  });

  test('renders with type submit', () => {
    renderButton({ type: 'submit', children: 'Submit' });

    const button = screen.getByRole('button', { name: 'Submit' });
    expect(button).toHaveAttribute('type', 'submit');
  });

  test('renders with aria-label from tooltip', () => {
    renderButton({ tooltip: 'Tooltip text', children: 'Button' });

    const button = screen.getByRole('button', { name: 'Tooltip text' });
    expect(button).toHaveAttribute('aria-label', 'Tooltip text');
  });

  test('renders with custom aria-label', () => {
    renderButton({ 'aria-label': 'Custom label', children: 'Button' });

    const button = screen.getByRole('button', { name: 'Custom label' });
    expect(button).toHaveAttribute('aria-label', 'Custom label');
  });

  test('tooltip takes precedence over aria-label', () => {
    renderButton({
      tooltip: 'Tooltip text',
      'aria-label': 'Custom label',
      children: 'Button',
    });

    const button = screen.getByRole('button', { name: 'Tooltip text' });
    expect(button).toHaveAttribute('aria-label', 'Tooltip text');
  });

  test('calls onClick handler when clicked', () => {
    const handleClick = vi.fn();
    const { user } = renderButton({
      onClick: handleClick,
      children: 'Click me',
    });

    const button = screen.getByRole('button', { name: 'Click me' });
    button.click();

    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});

// =============================================================================
// BASE STYLES TESTS
// =============================================================================

describe('Button - Base Styles', () => {
  test('applies base classes to all buttons', () => {
    renderButton({ children: 'Button' });

    const button = screen.getByRole('button', { name: 'Button' });
    expect(button).toHaveClass(
      'rounded-md',
      'text-sm',
      'font-semibold',
      'shadow-xs'
    );
  });

  test('includes focus-visible outline styles', () => {
    renderButton({ variant: 'primary', children: 'Focus test' });

    const button = screen.getByRole('button', { name: 'Focus test' });
    expect(button).toHaveClass(
      'focus-visible:outline-2',
      'focus-visible:outline-offset-2',
      'focus-visible:outline-primary-600'
    );
  });
});
