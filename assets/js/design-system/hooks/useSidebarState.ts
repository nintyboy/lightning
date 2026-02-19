/**
 * useSidebarState Hook
 *
 * Convenience hook for accessing sidebar state and actions.
 * Provides derived state values for easier consumption.
 *
 * Usage:
 * ```tsx
 * import { useSidebarState } from '@/design-system/hooks/useSidebarState';
 *
 * function Sidebar() {
 *   const { width, isExpanded, isCollapsed, isHidden } = useSidebarState();
 *   return <div style={{ width }} className="sidebar">...</div>;
 * }
 * ```
 */

import { useSidebarStore } from '../stores/sidebarStore';

export type SidebarWidth = '0px' | '64px' | '192px';

export interface SidebarState {
  // Raw state
  collapsed: boolean;
  hidden: boolean;

  // Derived state
  width: SidebarWidth;
  isExpanded: boolean;
  isCollapsed: boolean;
  isHidden: boolean;

  // Actions
  toggleCollapsed: () => void;
  toggleHidden: () => void;
  setCollapsed: (collapsed: boolean) => void;
  setHidden: (hidden: boolean) => void;
}

export function useSidebarState(): SidebarState {
  const {
    collapsed,
    hidden,
    toggleCollapsed,
    toggleHidden,
    setCollapsed,
    setHidden,
  } = useSidebarStore();

  // Derived state
  const width: SidebarWidth = hidden ? '0px' : collapsed ? '64px' : '192px';
  const isExpanded = !collapsed && !hidden;
  const isCollapsed = collapsed && !hidden;
  const isHidden = hidden;

  return {
    collapsed,
    hidden,
    width,
    isExpanded,
    isCollapsed,
    isHidden,
    toggleCollapsed,
    toggleHidden,
    setCollapsed,
    setHidden,
  };
}
