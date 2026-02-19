/**
 * Sidebar Store
 *
 * Zustand store with persist middleware for managing sidebar state.
 * Implements three-state sidebar: hidden (0px), collapsed (64px), expanded (192px)
 *
 * Usage:
 * ```tsx
 * import { useSidebarStore } from '@/design-system/stores/sidebarStore';
 *
 * function MyComponent() {
 *   const { collapsed, hidden, toggleCollapsed, toggleHidden } = useSidebarStore();
 *   ...
 * }
 * ```
 */

import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface SidebarStore {
  // State
  collapsed: boolean; // 64px state
  hidden: boolean; // 0px state

  // Actions
  toggleCollapsed: () => void;
  toggleHidden: () => void;
  setCollapsed: (collapsed: boolean) => void;
  setHidden: (hidden: boolean) => void;
}

export const useSidebarStore = create<SidebarStore>()(
  persist(
    set => ({
      // Initial state - sidebar is expanded (192px) by default
      collapsed: false,
      hidden: false,

      // Toggle collapsed state (192px <-> 64px)
      toggleCollapsed: () =>
        set(state => {
          // If sidebar is hidden, first show it in collapsed state
          if (state.hidden) {
            return { hidden: false, collapsed: true };
          }
          // Otherwise toggle collapsed state
          return { collapsed: !state.collapsed };
        }),

      // Toggle hidden state (expanded/collapsed <-> 0px)
      toggleHidden: () => set(state => ({ hidden: !state.hidden })),

      // Set collapsed state explicitly
      setCollapsed: collapsed => set({ collapsed }),

      // Set hidden state explicitly
      setHidden: hidden => set({ hidden }),
    }),
    {
      name: 'lightning-sidebar-state',
      // Persist to localStorage
      partialize: state => ({
        collapsed: state.collapsed,
        hidden: state.hidden,
      }),
    }
  )
);
