/**
 * Lightning Design System
 *
 * A collection of reusable React components that integrate with the
 * Lightning Phoenix LiveView application.
 *
 * @example
 * // Import specific components
 * import { Button, Badge, Input } from '@/design-system';
 *
 * // Import from subdirectories
 * import { Button } from '@/design-system/components/button';
 * import { useSidebarState } from '@/design-system/hooks/useSidebarState';
 */

// Components
export * from './components/button';
export * from './components/badge';
export * from './components/input';
export * from './components/select';
export * from './components/modal';
export * from './components/toast';
export * from './components/icon';
export * from './components/layout';

// Lib - avoid re-exporting types that conflict with component exports
export { cn } from './lib/cn';
export * from './lib/types';

// Hooks
export * from './hooks/useSidebarState';

// Stores
export { useSidebarStore } from './stores/sidebarStore';
