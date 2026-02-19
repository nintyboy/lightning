/**
 * SidebarFooter Component
 *
 * Footer section for the sidebar with toggle functionality.
 * Handles the collapse/expand button and branding elements.
 *
 * Source: https://github.com/OpenFn/lightning/blob/main/lib/lightning_web/components/layouts/live.html.heex
 */

import { cn } from '../../lib/cn';
import { useSidebarState } from '../../hooks/useSidebarState';
import type { ReactNode } from 'react';

export interface SidebarFooterProps {
  children?: ReactNode;
  brandingExpanded?: ReactNode;
  brandingCollapsed?: ReactNode;
  className?: string;
  theme?: 'primary' | 'secondary' | 'sudo';
}

export function SidebarFooter({
  children,
  brandingExpanded,
  brandingCollapsed,
  className,
  theme = 'primary',
}: SidebarFooterProps) {
  const { isExpanded, isCollapsed, toggleCollapsed } = useSidebarState();

  return (
    <div
      className={cn(
        'sidebar-footer p-2 flex items-center gap-2',
        theme === 'primary' && 'bg-primary-900',
        theme === 'secondary' && 'bg-blue-900',
        theme === 'sudo' && 'bg-slate-900',
        className
      )}
    >
      {/* Branding - shown based on state */}
      {brandingExpanded && (
        <div
          className={cn(
            'sidebar-logo-text sidebar-branding-expanded transition-all duration-200',
            isExpanded ? 'max-w-50 mr-1 opacity-100' : 'max-w-0 mr-0 opacity-0'
          )}
        >
          {brandingExpanded}
        </div>
      )}

      {brandingCollapsed && (
        <div
          className={cn(
            'sidebar-branding-collapsed transition-all duration-200',
            isCollapsed ? 'block' : 'hidden'
          )}
        >
          {brandingCollapsed}
        </div>
      )}

      {/* Spacer */}
      <div className="flex-1" />

      {/* Collapse/Expand button */}
      <button
        type="button"
        onClick={toggleCollapsed}
        className={cn(
          'sidebar-toggle-btn p-1.5 rounded-md hover:bg-white/10 transition-colors',
          isExpanded && 'w-full'
        )}
        aria-label={isExpanded ? 'Collapse sidebar' : 'Expand sidebar'}
      >
        <div className="flex items-center">
          {/* Collapse icon - shown when expanded */}
          <span
            className={cn(
              'sidebar-collapse-icon hero-chevron-left',
              isExpanded ? 'block' : 'hidden'
            )}
          />
          {/* Expand icon - shown when collapsed */}
          <span
            className={cn(
              'sidebar-expand-icon hero-chevron-right',
              isCollapsed ? 'block' : 'hidden'
            )}
          />
        </div>
      </button>

      {/* Additional footer content */}
      {children}
    </div>
  );
}
