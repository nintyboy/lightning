defmodule LightningWeb.Storybook.DesignSystem.Modal do
  use PhoenixStorybook.Story, :page

  def doc, do: "Modal component documentation"

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
        <h2 class="text-2xl font-bold mb-4">Modal Component</h2>
        <p class="text-gray-600 mb-4">
          A dialog component with portal rendering and keyboard handling. The Modal component
          provides a consistent way to display overlays for user interactions requiring focus.
        </p>
      </div>

      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <h3 class="font-semibold text-blue-900 mb-2">React Component Only</h3>
        <p class="text-blue-800 text-sm">
          The Modal component is a React component that uses React Portal for rendering and
          cannot be used directly in PhoenixStorybook or HEEx templates. It must be used
          within a React application context.
        </p>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Key Features</h3>
        <ul class="list-disc list-inside space-y-2 text-gray-700">
          <li>
            Portal rendering to
            <code class="bg-gray-100 px-2 py-0.5 rounded">document.body</code>
          </li>
          <li>Four size variants: sm, md (default), lg, xl</li>
          <li>Keyboard support (Escape key to close)</li>
          <li>Backdrop click to close</li>
          <li>Optional close button</li>
          <li>Accessibility attributes (ARIA role, labelledby, describedby)</li>
          <li>Smooth fade-in animation</li>
        </ul>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Size Variants</h3>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Size
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Max Width
                </th>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Use Case
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr>
                <td class="px-3 py-4 text-sm text-gray-900">
                  <code class="bg-gray-100 px-2 py-0.5 rounded">sm</code>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">24rem (384px)</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Confirmations, alerts
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm text-gray-900">
                  <code class="bg-gray-100 px-2 py-0.5 rounded">md</code>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">28rem (448px)</td>
                <td class="px-3 py-4 text-sm text-gray-700">Default, forms</td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm text-gray-900">
                  <code class="bg-gray-100 px-2 py-0.5 rounded">lg</code>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">32rem (512px)</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Complex forms, content
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm text-gray-900">
                  <code class="bg-gray-100 px-2 py-0.5 rounded">xl</code>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">36rem (576px)</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Large content, detailed views
                </td>
              </tr>
            </tbody>
          </table>
        </div>
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
        <h3 class="text-lg font-semibold mb-3">Props</h3>
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
                <td class="px-3 py-4 text-sm font-mono text-gray-900">isOpen</td>
                <td class="px-3 py-4 text-sm text-gray-700">boolean</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  <span class="text-red-600">required</span>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Controls modal visibility
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">onClose</td>
                <td class="px-3 py-4 text-sm text-gray-700">() =&gt; void</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  <span class="text-red-600">required</span>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Callback when modal should close
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">children</td>
                <td class="px-3 py-4 text-sm text-gray-700">ReactNode</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  <span class="text-red-600">required</span>
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">Modal content</td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">size</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  'sm' | 'md' | 'lg' | 'xl'
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">'md'</td>
                <td class="px-3 py-4 text-sm text-gray-700">Modal size variant</td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">title</td>
                <td class="px-3 py-4 text-sm text-gray-700">string</td>
                <td class="px-3 py-4 text-sm text-gray-700">undefined</td>
                <td class="px-3 py-4 text-sm text-gray-700">Modal title (header)</td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">
                  description
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">string</td>
                <td class="px-3 py-4 text-sm text-gray-700">undefined</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Accessibility description
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">
                  showCloseButton
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">boolean</td>
                <td class="px-3 py-4 text-sm text-gray-700">true</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Show X button in header
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
        <h3 class="text-lg font-semibold mb-3">Basic Modal</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">import &#123; Modal &#125; from '@/design-system/components/modal';
    import &#123; useState &#125; from 'react';

    function MyComponent() &#123;
    const [isOpen, setIsOpen] = useState(false);

    return (
    &lt;&gt;
      &lt;button onClick=&#123;() =&gt; setIsOpen(true)&#125;&gt;
        Open Modal
      &lt;/button&gt;

      &lt;Modal
        isOpen=&#123;isOpen&#125;
        onClose=&#123;() =&gt; setIsOpen(false)&#125;
        title="Confirm Action"
      &gt;
        &lt;p&gt;Are you sure you want to proceed?&lt;/p&gt;
        &lt;div className="mt-4 flex gap-2"&gt;
          &lt;button onClick=&#123;() =&gt; setIsOpen(false)&#125;&gt;
            Cancel
          &lt;/button&gt;
          &lt;button onClick=&#123;handleConfirm&#125;&gt;
            Confirm
          &lt;/button&gt;
        &lt;/div&gt;
      &lt;/Modal&gt;
    &lt;/&gt;
    );
    &#125;</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Modal with Form</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">&lt;Modal
    isOpen=&#123;isOpen&#125;
    onClose=&#123;() =&gt; setIsOpen(false)&#125;
    title="Edit Profile"
    size="lg"
    description="Update your profile information"
    &gt;
    &lt;form onSubmit=&#123;handleSubmit&#125;&gt;
    &lt;InputField
      name="name"
      label="Full Name"
      required
    /&gt;
    &lt;InputField
      name="email"
      type="email"
      label="Email"
      required
    /&gt;
    &lt;div className="mt-6 flex justify-end gap-3"&gt;
      &lt;Button variant="secondary" onClick=&#123;() =&gt; setIsOpen(false)&#125;&gt;
        Cancel
      &lt;/Button&gt;
      &lt;Button type="submit"&gt;
        Save Changes
      &lt;/Button&gt;
    &lt;/div&gt;
    &lt;/form&gt;
    &lt;/Modal&gt;</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Simple Alert Modal</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">&lt;Modal
    isOpen=&#123;isOpen&#125;
    onClose=&#123;() =&gt; setIsOpen(false)&#125;
    size="sm"
    &gt;
    &lt;div className="text-center"&gt;
    &lt;Icon name="hero-check-circle" size="xl" className="text-green-600 mx-auto mb-4" /&gt;
    &lt;h3 className="text-lg font-semibold mb-2"&gt;Success!&lt;/h3&gt;
    &lt;p className="text-gray-600"&gt;Your changes have been saved.&lt;/p&gt;
    &lt;/div&gt;
    &lt;/Modal&gt;</code></pre>
      </div>
    </div>
    """
  end
end
