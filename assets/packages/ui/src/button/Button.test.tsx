import { describe, expect, it, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { axe } from 'vitest-axe';
import '@testing-library/jest-dom/vitest';

import recipe from '../../recipes/button.json';
import { Button, buttonVariants } from './Button';
import { SplitButton } from './SplitButton';

const variantNames = Object.keys(recipe.variants) as Array<
  keyof typeof recipe.variants
>;

describe('buttonVariants (recipe contract)', () => {
  it('exposes every recipe variant and size', () => {
    for (const variant of variantNames) {
      const enabled = buttonVariants({ variant, vstate: 'enabled' });
      const disabled = buttonVariants({ variant, vstate: 'disabled' });
      for (const cls of recipe.variants[variant].enabled
        .split(/\s+/)
        .filter(Boolean)) {
        expect(enabled).toContain(cls);
      }
      for (const cls of recipe.variants[variant].disabled
        .split(/\s+/)
        .filter(Boolean)) {
        expect(disabled).toContain(cls);
      }
    }
    for (const [size, classes] of Object.entries(recipe.sizes)) {
      expect(
        buttonVariants({ size: size as keyof typeof recipe.sizes })
      ).toContain(classes.split(/\s+/)[0]);
    }
  });

  it('never leaks hover classes into the disabled state', () => {
    for (const variant of variantNames) {
      expect(buttonVariants({ variant, vstate: 'disabled' })).not.toMatch(
        /(?:^|\s)hover:/
      );
    }
  });
});

describe('Button', () => {
  it('renders every recipe variant', () => {
    for (const variant of variantNames) {
      const { unmount } = render(<Button variant={variant}>{variant}</Button>);
      const btn = screen.getByRole('button', { name: variant });
      const expected = recipe.variants[variant].enabled.split(/\s+/)[0];
      if (expected) expect(btn.className).toContain(expected);
      unmount();
    }
  });

  it('fires onClick via keyboard and pointer (react-aria press)', async () => {
    const user = userEvent.setup();
    const onClick = vi.fn();
    render(<Button onClick={onClick}>Save</Button>);
    const btn = screen.getByRole('button', { name: 'Save' });
    await user.click(btn);
    btn.focus();
    await user.keyboard('{Enter}');
    expect(onClick).toHaveBeenCalledTimes(2);
  });

  it('swaps to disabled classes and blocks clicks when disabled or loading', async () => {
    const user = userEvent.setup();
    const onClick = vi.fn();
    render(
      <Button variant="primary" disabled onClick={onClick}>
        Save
      </Button>
    );
    const btn = screen.getByRole('button', { name: 'Save' });
    expect(btn).toBeDisabled();
    expect(btn.className).toContain('bg-primary-300');
    expect(btn.className).not.toContain('hover:bg-primary-500');
    await user.click(btn);
    expect(onClick).not.toHaveBeenCalled();

    const { container } = render(
      <Button loading onClick={onClick}>
        Loading
      </Button>
    );
    const loadingBtn = container.querySelector('button');
    expect(loadingBtn).toBeDisabled();
  });

  it('renders left/right icons as decoration (aria-hidden)', () => {
    render(
      <Button
        iconLeft={<span data-testid="l" />}
        iconRight={<span data-testid="r" />}
      >
        Label
      </Button>
    );
    expect(screen.getByTestId('l').parentElement).toHaveAttribute(
      'aria-hidden',
      'true'
    );
    expect(screen.getByTestId('r').parentElement).toHaveAttribute(
      'aria-hidden',
      'true'
    );
  });

  it('icon-only buttons carry the required accessible name', () => {
    render(
      <Button
        size="icon"
        aria-label="Copy code"
        iconLeft={<span className="hero-clipboard size-4" />}
      />
    );
    expect(
      screen.getByRole('button', { name: 'Copy code' })
    ).toBeInTheDocument();
  });

  it('submits forms via type="submit"', async () => {
    const user = userEvent.setup();
    const onSubmit = vi.fn(e => e.preventDefault());
    render(
      <form onSubmit={onSubmit}>
        <Button type="submit">Go</Button>
      </form>
    );
    await user.click(screen.getByRole('button', { name: 'Go' }));
    expect(onSubmit).toHaveBeenCalledTimes(1);
  });

  it('has no axe violations (labelled, disabled, icon-only)', async () => {
    const { container } = render(
      <div>
        <Button>Save</Button>
        <Button variant="secondary" disabled>
          Cancel
        </Button>
        <Button
          variant="ghost"
          size="icon"
          aria-label="Close"
          iconLeft={<span className="hero-x-mark size-4" />}
        />
      </div>
    );
    expect((await axe(container)).violations).toEqual([]);
  });
});

describe('SplitButton', () => {
  it('fires the primary action and opens the menu from the trigger', async () => {
    const user = userEvent.setup();
    const onClick = vi.fn();
    const onAction = vi.fn();
    render(
      <SplitButton
        onClick={onClick}
        menuLabel="More save options"
        items={[{ id: 'sync', label: 'Save & Sync', onAction }]}
      >
        Save
      </SplitButton>
    );
    await user.click(screen.getByRole('button', { name: 'Save' }));
    expect(onClick).toHaveBeenCalledTimes(1);

    await user.click(screen.getByRole('button', { name: 'More save options' }));
    await user.click(
      await screen.findByRole('menuitem', { name: 'Save & Sync' })
    );
    expect(onAction).toHaveBeenCalledTimes(1);
  });

  it('has no axe violations with the menu open', async () => {
    const user = userEvent.setup();
    const { baseElement } = render(
      <SplitButton
        menuLabel="More options"
        items={[{ id: 'a', label: 'Alternative' }]}
      >
        Primary
      </SplitButton>
    );
    await user.click(screen.getByRole('button', { name: 'More options' }));
    await screen.findByRole('menu');
    expect((await axe(baseElement)).violations).toEqual([]);
  });
});
