import type { Meta, StoryObj } from '@storybook/react-vite';
import { expect, fn, userEvent, within, screen } from 'storybook/test';

import { SplitButton } from './SplitButton';

const meta = {
  title: 'UI/SplitButton',
  component: SplitButton,
  parameters: { layout: 'centered' },
  args: {
    children: 'Save',
    menuLabel: 'More save options',
    onClick: fn(),
    items: [
      { id: 'sync', label: 'Save & Sync', onAction: fn() },
      { id: 'template', label: 'Save as template', isDisabled: true },
    ],
  },
  tags: ['autodocs'],
} satisfies Meta<typeof SplitButton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  play: async ({ args, canvasElement }) => {
    const canvas = within(canvasElement);
    await userEvent.click(canvas.getByRole('button', { name: 'Save' }));
    await expect(args.onClick).toHaveBeenCalled();
    await userEvent.click(
      canvas.getByRole('button', { name: 'More save options' })
    );
    // Popover renders in a portal → search the whole screen
    await expect(await screen.findByRole('menu')).toBeVisible();
  },
};

export const Secondary: Story = {
  args: { variant: 'secondary', children: 'Run' },
};

export const Disabled: Story = {
  args: { disabled: true },
};
