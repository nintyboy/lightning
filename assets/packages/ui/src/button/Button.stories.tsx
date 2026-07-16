import type { Meta, StoryObj } from '@storybook/react-vite';
import {
  ArrowRightIcon,
  ClipboardIcon,
  PlusIcon,
  XMarkIcon,
} from '@heroicons/react/20/solid';
import { expect, fn, userEvent, within } from 'storybook/test';

import recipe from '../../recipes/button.json';
import { Button } from './Button';

const variantNames = Object.keys(recipe.variants) as Array<
  keyof typeof recipe.variants
>;

const meta = {
  title: 'UI/Button',
  component: Button,
  parameters: { layout: 'centered' },
  args: { onClick: fn() },
  argTypes: {
    variant: { control: 'select', options: [...variantNames, 'nakedClose'] },
    size: { control: 'select', options: Object.keys(recipe.sizes) },
  },
  tags: ['autodocs'],
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: { children: 'Save', variant: 'primary' },
  play: async ({ args, canvasElement }) => {
    const canvas = within(canvasElement);
    await userEvent.click(canvas.getByRole('button', { name: 'Save' }));
    await expect(args.onClick).toHaveBeenCalled();
  },
};

export const AllVariants: Story = {
  args: { children: 'x' },
  render: () => (
    <div className="flex flex-wrap items-center gap-3">
      {variantNames
        .filter(v => v !== 'custom')
        .map(v => (
          <Button key={v} variant={v}>
            {v}
          </Button>
        ))}
    </div>
  ),
};

export const Sizes: Story = {
  args: { children: 'x' },
  render: () => (
    <div className="flex items-center gap-3">
      <Button size="sm">Small</Button>
      <Button size="md">Medium</Button>
      <Button size="lg">Large</Button>
      <Button
        size="icon"
        aria-label="Icon only"
        iconLeft={<PlusIcon className="size-4" />}
      />
    </div>
  ),
};

export const WithIcons: Story = {
  args: { children: 'x' },
  render: () => (
    <div className="flex items-center gap-3">
      <Button iconLeft={<PlusIcon className="size-4" />}>Create</Button>
      <Button
        variant="secondary"
        iconRight={<ArrowRightIcon className="size-4" />}
      >
        Next
      </Button>
      <Button
        variant="ghost"
        size="icon"
        aria-label="Copy"
        iconLeft={<ClipboardIcon className="size-4" />}
      />
    </div>
  ),
};

export const DisabledStates: Story = {
  args: { children: 'x' },
  render: () => (
    <div className="flex flex-wrap items-center gap-3">
      {variantNames
        .filter(v => v !== 'custom')
        .map(v => (
          <Button key={v} variant={v} disabled>
            {v}
          </Button>
        ))}
    </div>
  ),
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    for (const btn of canvas.getAllByRole('button')) {
      await expect(btn).toBeDisabled();
    }
  },
};

export const Loading: Story = {
  args: { children: 'Saving…', loading: true },
  play: async ({ canvasElement }) => {
    const btn = within(canvasElement).getByRole('button');
    await expect(btn).toBeDisabled();
    await expect(btn).toHaveAttribute('aria-busy', 'true');
  },
};
