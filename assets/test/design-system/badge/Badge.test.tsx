/**
 * Badge Component Unit Tests
 *
 * Tests for the Badge component from the design system.
 * Focuses on variant rendering and close button functionality.
 */

import { render, screen } from '@testing-library/react';
import { describe, expect, test, vi } from 'vitest';

import { Badge } from '#/design-system/components/badge';

// =============================================================================
// TEST HELPERS
// =============================================================================

function renderBadge(props: React.ComponentProps<typeof Badge>) {
  return render(<Badge {...props} />);
}

// =============================================================================
// VARIANT TESTS
// =============================================================================

describe('Badge - Variants', () => {
  test('renders gray variant by default', () => {
    renderBadge({ children: 'Default' });

    const badge = screen.getByText('Default').parentElement;
    expect(badge).toHaveClass('bg-gray-100', 'text-gray-700');
  });

  test('renders red variant correctly', () => {
    renderBadge({ variant: 'red', children: 'Error' });

    const badge = screen.getByText('Error').parentElement;
    expect(badge).toHaveClass('bg-red-100', 'text-red-700');
  });

  test('renders yellow variant correctly', () => {
    renderBadge({ variant: 'yellow', children: 'Warning' });

    const badge = screen.getByText('Warning').parentElement;
    expect(badge).toHaveClass('bg-yellow-100', 'text-yellow-800');
  });

  test('renders green variant correctly', () => {
    renderBadge({ variant: 'green', children: 'Success' });

    const badge = screen.getByText('Success').parentElement;
    expect(badge).toHaveClass('bg-green-100', 'text-green-700');
  });

  test('renders blue variant correctly', () => {
    renderBadge({ variant: 'blue', children: 'Info' });

    const badge = screen.getByText('Info').parentElement;
    expect(badge).toHaveClass('bg-blue-100', 'text-blue-700');
  });

  test('renders indigo variant correctly', () => {
    renderBadge({ variant: 'indigo', children: 'Active' });

    const badge = screen.getByText('Active').parentElement;
    expect(badge).toHaveClass('bg-indigo-100', 'text-indigo-700');
  });
});

// =============================================================================
// CLOSE BUTTON TESTS
// =============================================================================

describe('Badge - Close Button', () => {
  test('does not render close button by default', () => {
    renderBadge({ children: 'No close' });

    const closeButton = screen.queryByLabelText('Remove');
    expect(closeButton).not.toBeInTheDocument();
  });

  test('renders close button when onClose is provided', () => {
    const handleClose = vi.fn();
    renderBadge({ onClose: handleClose, children: 'With close' });

    const closeButton = screen.getByLabelText('Remove');
    expect(closeButton).toBeInTheDocument();
  });

  test('calls onClose when close button is clicked', () => {
    const handleClose = vi.fn();
    renderBadge({ onClose: handleClose, children: 'Click close' });

    const closeButton = screen.getByLabelText('Remove');
    closeButton.click();

    expect(handleClose).toHaveBeenCalledTimes(1);
  });
});

// =============================================================================
// STYLING TESTS
// =============================================================================

describe('Badge - Styling', () => {
  test('applies base classes to all badges', () => {
    renderBadge({ children: 'Badge' });

    const badge = screen.getByText('Badge').parentElement;
    expect(badge).toHaveClass(
      'inline-flex',
      'items-center',
      'gap-x-1',
      'rounded-md',
      'px-2',
      'py-1',
      'text-xs',
      'font-medium'
    );
  });

  test('applies custom className', () => {
    renderBadge({ className: 'custom-class', children: 'Custom' });

    const badge = screen.getByText('Custom').parentElement;
    expect(badge).toHaveClass('custom-class');
  });

  test('adjusts padding when close button is present', () => {
    const handleClose = vi.fn();
    renderBadge({ onClose: handleClose, children: 'Padded' });

    const badge = screen.getByText('Padded').parentElement;
    expect(badge).toHaveClass('pr-1');
  });
});
