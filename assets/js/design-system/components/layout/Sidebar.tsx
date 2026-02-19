/**
 * Sidebar Component
 *
 * React sidebar component with three-state collapsibility:
 * - Expanded: 192px width, full menu visible
 * - Collapsed: 64px width, icons only
 * - Hidden: 0px width, completely off-screen
 *
 * Integrates with the existing LiveView sidebar via useSidebarState hook.
 *
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/layouts/live.html.heex#L18-L79
 */

import { cn } from '../../lib/cn';
import { useSidebarState } from '../../hooks/useSidebarState';
import type { ReactNode } from 'react';

export interface SidebarProps {
  children: ReactNode;
  className?: string;
  theme?: 'primary' | 'secondary' | 'sudo';
}

const themeClasses = {
  primary: 'bg-primary-800 text-white',
  secondary: 'bg-blue-700 text-white',
  sudo: 'bg-slate-700 text-white',
};

export function Sidebar({
  children,
  className,
  theme = 'primary',
}: SidebarProps) {
  const { width, isExpanded, isCollapsed, isHidden } = useSidebarState();

  return (
    <>
      {/* Placeholder - maintains layout width */}
      <div
        className={cn(
          'flex-shrink-0 transition-[width] duration-200',
          isExpanded && 'w-48',
          isCollapsed && 'w-16',
          isHidden && 'w-0'
        )}
      />

      {/* Sidebar panel - overlays when collapsed/hidden */}
      <div
        id="sidebar-panel"
        data-collapsed={isCollapsed.toString()}
        data-hidden={isHidden.toString()}
        className={cn(
          'flex flex-col h-full z-[100] group transition-[width] duration-200 fixed',
          themeClasses[theme],
          className
        )}
        style={{ width }}
      >
        {children}
      </div>
    </>
  );
}

/**
 * SidebarHeader component for the logo and user menu area
 */
export interface SidebarHeaderProps {
  children: ReactNode;
  className?: string;
  theme?: 'primary' | 'secondary' | 'sudo';
}

export function SidebarHeader({
  children,
  className,
  theme = 'primary',
}: SidebarHeaderProps) {
  const { isExpanded, isCollapsed } = useSidebarState();

  return (
    <div
      className={cn(
        'app-logo-container h-20 flex items-center',
        isExpanded && 'justify-between',
        isCollapsed && 'justify-center',
        // Theme classes
        theme === 'primary' && 'bg-primary-900 text-white',
        theme === 'secondary' && 'bg-blue-900 text-white',
        theme === 'sudo' && 'bg-slate-900 text-white',
        className
      )}
    >
      {children}
    </div>
  );
}

/**
 * SidebarContent component for scrollable menu items
 */
export interface SidebarContentProps {
  children: ReactNode;
  className?: string;
  theme?: 'primary' | 'secondary' | 'sudo';
}

export function SidebarContent({
  children,
  className,
  theme = 'primary',
}: SidebarContentProps) {
  const themeBgClass = {
    primary: 'bg-primary-800',
    secondary: 'bg-blue-700',
    sudo: 'bg-slate-700',
  };

  return (
    <nav
      className={cn('flex-1 overflow-hidden', themeBgClass[theme], className)}
    >
      <div className="flex flex-col h-full">
        <div className="flex-1 py-4 overflow-y-auto min-h-0 flex flex-col">
          {children}
        </div>
      </div>
    </nav>
  );
}
