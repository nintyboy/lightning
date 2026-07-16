import type { StorybookConfig } from '@storybook/react-vite';

const config: StorybookConfig = {
  stories: ['../src/**/*.stories.@(ts|tsx)'],
  addons: ['@storybook/addon-a11y'],
  framework: { name: '@storybook/react-vite', options: {} },
  async viteFinal(config) {
    const tailwindcss = (await import('@tailwindcss/vite')).default;
    config.plugins = [...(config.plugins ?? []), tailwindcss()];
    // Prevent vite picking up the app's legacy v3-era .postcssrc from
    // assets/ — @tailwindcss/vite does all CSS processing for this package.
    config.css = { ...config.css, postcss: { plugins: [] } };
    return config;
  },
};

export default config;
