defmodule LightningWeb.Storybook.DesignSystem.Sidebar do
  use PhoenixStorybook.Story, :page

  def doc, do: "Sidebar component documentation"

  def navigation do
    [
      {:overview, "Overview", {:fa, "eye", :regular}},
      {:api, "API Reference", {:fa, "code", :regular}},
      {:examples, "Examples", {:fa, "book", :regular}}
    ]
  end

  def render(assigns = %{tab: :overview}) do
    ~H"""
    <div class="p-8 space-y-8 max-w-4xl">
      <div>
        <h2 class="text-2xl font-bold mb-4">Sidebar Component</h2>
        <p class="text-gray-600 mb-4">
          React sidebar component with three-state collapsibility that integrates with
          Lightning's LiveView sidebar state management via Zustand.
        </p>
      </div>

      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <h3 class="font-semibold text-blue-900 mb-2">React Component Only</h3>
        <p class="text-blue-800 text-sm">
          The Sidebar component is a React component that uses Zustand for state management
          and cannot be used directly in PhoenixStorybook or HEEx templates. It must be used
          within a React application context.
        </p>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Key Features</h3>
        <ul class="list-disc list-inside space-y-2 text-gray-700">
          <li>
            Three-state collapsibility: Expanded (192px), Collapsed (64px), Hidden (0px)
          </li>
          <li>Smooth width transitions with CSS animations</li>
          <li>Three theme variants: primary (default), secondary, sudo</li>
          <li>Integrates with useSidebarState Zustand hook</li>
          <li>Fixed positioning with layout placeholder to prevent content shift</li>
          <li>
            Composed from sub-components: Sidebar, SidebarHeader, SidebarContent, SidebarFooter
          </li>
        </ul>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Three-State Behavior</h3>
        <div class="space-y-3">
          <div class="flex items-start gap-3 p-3 bg-gray-50 border border-gray-200 rounded-lg">
            <div class="flex-shrink-0 w-32 font-mono text-sm text-gray-900">
              Expanded
            </div>
            <div class="text-sm text-gray-700">
              <div class="font-medium mb-1">192px width</div>
              <div>Full menu visible with labels and icons</div>
            </div>
          </div>
          <div class="flex items-start gap-3 p-3 bg-gray-50 border border-gray-200 rounded-lg">
            <div class="flex-shrink-0 w-32 font-mono text-sm text-gray-900">
              Collapsed
            </div>
            <div class="text-sm text-gray-700">
              <div class="font-medium mb-1">64px width</div>
              <div>Icons only, labels hidden</div>
            </div>
          </div>
          <div class="flex items-start gap-3 p-3 bg-gray-50 border border-gray-200 rounded-lg">
            <div class="flex-shrink-0 w-32 font-mono text-sm text-gray-900">
              Hidden
            </div>
            <div class="text-sm text-gray-700">
              <div class="font-medium mb-1">0px width</div>
              <div>Completely off-screen, typically for mobile views</div>
            </div>
          </div>
        </div>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Theme Variants</h3>
        <div class="space-y-3">
          <div class="flex items-center gap-3 p-3 bg-primary-800 text-white rounded-lg">
            <div class="flex-shrink-0 w-24 font-mono text-sm">primary</div>
            <div class="text-sm">Default primary blue theme</div>
          </div>
          <div class="flex items-center gap-3 p-3 bg-blue-700 text-white rounded-lg">
            <div class="flex-shrink-0 w-24 font-mono text-sm">secondary</div>
            <div class="text-sm">Lighter blue variant</div>
          </div>
          <div class="flex items-center gap-3 p-3 bg-slate-700 text-white rounded-lg">
            <div class="flex-shrink-0 w-24 font-mono text-sm">sudo</div>
            <div class="text-sm">Dark slate theme for elevated access</div>
          </div>
        </div>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">State Management</h3>
        <p class="text-gray-600 mb-3">
          The Sidebar uses the
          <code class="bg-gray-100 px-2 py-0.5 rounded">useSidebarState</code>
          Zustand hook
          which provides:
        </p>
        <ul class="list-disc list-inside space-y-1 text-gray-700 text-sm">
          <li>
            <code class="bg-gray-100 px-2 py-0.5 rounded">width</code>
            - Current sidebar width in pixels
          </li>
          <li>
            <code class="bg-gray-100 px-2 py-0.5 rounded">isExpanded</code>
            - Boolean indicating expanded state
          </li>
          <li>
            <code class="bg-gray-100 px-2 py-0.5 rounded">isCollapsed</code>
            - Boolean indicating collapsed state
          </li>
          <li>
            <code class="bg-gray-100 px-2 py-0.5 rounded">isHidden</code>
            - Boolean indicating hidden state
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def render(assigns = %{tab: :api}) do
    ~H"""
    <div class="p-8 space-y-8 max-w-4xl">
      <div>
        <h2 class="text-2xl font-bold mb-4">API Reference</h2>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Sidebar Props</h3>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Prop
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Type
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Default
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Description
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">children</td>
                <td class="px-3 py-4 text-sm text-gray-700">ReactNode</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  <span class="text-red-600">required</span>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">Sidebar content</td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">theme</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  'primary' | 'secondary' | 'sudo'
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">'primary'</td>
                <td class="px-3 py-4 text-sm text-gray-700">Color theme variant</td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">className</td>
                <td class="px-3 py-4 text-sm text-gray-700">string</td>
                <td class="px-3 py-4 text-sm text-gray-700">undefined</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Additional CSS classes
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3 mt-6">SidebarHeader Props</h3>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Prop
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Type
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Default
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Description
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">children</td>
                <td class="px-3 py-4 text-sm text-gray-700">ReactNode</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  <span class="text-red-600">required</span>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Header content (logo, user menu)
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">theme</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  'primary' | 'secondary' | 'sudo'
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">'primary'</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Darker shade of theme color
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">className</td>
                <td class="px-3 py-4 text-sm text-gray-700">string</td>
                <td class="px-3 py-4 text-sm text-gray-700">undefined</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Additional CSS classes
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3 mt-6">SidebarContent Props</h3>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Prop
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Type
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Default
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Description
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">children</td>
                <td class="px-3 py-4 text-sm text-gray-700">ReactNode</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  <span class="text-red-600">required</span>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Scrollable navigation content
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">theme</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  'primary' | 'secondary' | 'sudo'
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">'primary'</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Background color for content
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">className</td>
                <td class="px-3 py-4 text-sm text-gray-700">string</td>
                <td class="px-3 py-4 text-sm text-gray-700">undefined</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Additional CSS classes
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  def render(assigns = %{tab: :examples}) do
    ~H"""
    <div class="p-8 space-y-8 max-w-4xl">
      <div>
        <h2 class="text-2xl font-bold mb-4">Usage Examples</h2>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Basic Sidebar</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">import &#123; Sidebar, SidebarHeader, SidebarContent &#125; from '@/design-system/components/layout';

    function AppLayout() &#123;
    return (
    &lt;div className="flex h-screen"&gt;
      &lt;Sidebar theme="primary"&gt;
        &lt;SidebarHeader theme="primary"&gt;
          &lt;Logo /&gt;
        &lt;/SidebarHeader&gt;

        &lt;SidebarContent theme="primary"&gt;
          &lt;nav&gt;
            &lt;MenuItem icon="hero-home" label="Dashboard" /&gt;
            &lt;MenuItem icon="hero-folder" label="Projects" /&gt;
            &lt;MenuItem icon="hero-users" label="Team" /&gt;
          &lt;/nav&gt;
        &lt;/SidebarContent&gt;
      &lt;/Sidebar&gt;

      &lt;main className="flex-1"&gt;
        &#123;/* Your app content */&#125;
      &lt;/main&gt;
    &lt;/div&gt;
    );
    &#125;</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">With SidebarFooter</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">import &#123; Sidebar, SidebarHeader, SidebarContent, SidebarFooter &#125; from '@/design-system/components/layout';

    &lt;Sidebar&gt;
    &lt;SidebarHeader&gt;
    &lt;Logo /&gt;
    &lt;/SidebarHeader&gt;

    &lt;SidebarContent&gt;
    &lt;NavigationMenu /&gt;
    &lt;/SidebarContent&gt;

    &lt;SidebarFooter&gt;
    &lt;UserMenu /&gt;
    &lt;/SidebarFooter&gt;
    &lt;/Sidebar&gt;</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Using Sidebar State</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">import &#123; useSidebarState &#125; from '@/design-system/hooks/useSidebarState';

    function MenuItem(&#123; icon, label &#125;) &#123;
    const &#123; isExpanded &#125; = useSidebarState();

    return (
    &lt;a href="#" className="flex items-center gap-3 px-4 py-2"&gt;
      &lt;Icon name=&#123;icon&#125; /&gt;
      &#123;isExpanded && &lt;span&gt;&#123;label&#125;&lt;/span&gt;&#125;
    &lt;/a&gt;
    );
    &#125;</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Theme Variants</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">// Primary theme (default - blue)
    &lt;Sidebar theme="primary"&gt;...&lt;/Sidebar&gt;

    // Secondary theme (lighter blue)
    &lt;Sidebar theme="secondary"&gt;...&lt;/Sidebar&gt;

    // Sudo theme (dark slate for elevated access)
    &lt;Sidebar theme="sudo"&gt;...&lt;/Sidebar&gt;</code></pre>
      </div>
    </div>
    """
  end
end
