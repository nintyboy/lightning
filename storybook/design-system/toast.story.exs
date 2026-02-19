defmodule LightningWeb.Storybook.DesignSystem.Toast do
  use PhoenixStorybook.Story, :page

  def doc, do: "Toast notification component documentation"

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
        <h2 class="text-2xl font-bold mb-4">Toast Component</h2>
        <p class="text-gray-600 mb-4">
          The Toast component extends Sonner with typed variants for consistent notification styling.
          It provides a simple, global API for showing toast notifications in React applications.
        </p>
      </div>

      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <h3 class="font-semibold text-blue-900 mb-2">React Component Only</h3>
        <p class="text-blue-800 text-sm">
          The Toast component is a React wrapper around Sonner and cannot be rendered directly
          in PhoenixStorybook or HEEx templates. It must be used within a React application.
        </p>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Key Features</h3>
        <ul class="list-disc list-inside space-y-2 text-gray-700">
          <li>Global singleton toast manager (via Sonner)</li>
          <li>Four typed variants: success, error, info, warning</li>
          <li>Promise-based toasts for async operations</li>
          <li>Dismissible toasts with optional duration</li>
          <li>Stacking support for multiple toasts</li>
          <li>Accessible keyboard navigation</li>
        </ul>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Toast Variants</h3>
        <div class="space-y-3">
          <div class="flex items-center gap-3 p-3 bg-green-50 border border-green-200 rounded-lg">
            <div class="flex-shrink-0 w-24 font-mono text-sm text-green-900">
              success
            </div>
            <div class="text-sm text-gray-700">
              Positive confirmations (saved, created, updated)
            </div>
          </div>
          <div class="flex items-center gap-3 p-3 bg-red-50 border border-red-200 rounded-lg">
            <div class="flex-shrink-0 w-24 font-mono text-sm text-red-900">
              error
            </div>
            <div class="text-sm text-gray-700">
              Failures and errors (validation failed, network error)
            </div>
          </div>
          <div class="flex items-center gap-3 p-3 bg-blue-50 border border-blue-200 rounded-lg">
            <div class="flex-shrink-0 w-24 font-mono text-sm text-blue-900">
              info
            </div>
            <div class="text-sm text-gray-700">
              Neutral information (status updates, reminders)
            </div>
          </div>
          <div class="flex items-center gap-3 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
            <div class="flex-shrink-0 w-24 font-mono text-sm text-yellow-900">
              warning
            </div>
            <div class="text-sm text-gray-700">
              Caution messages (quota warnings, deprecation notices)
            </div>
          </div>
        </div>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Setup</h3>
        <p class="text-gray-600 mb-3">
          Add the
          <code class="bg-gray-100 px-2 py-0.5 rounded">&lt;Toaster /&gt;</code>
          component
          to your app root (typically in App.tsx or a layout component):
        </p>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">import &#123; Toaster &#125; from '@/design-system/components/toast';

    function App() &#123;
    return (
    &lt;&gt;
      &lt;Toaster /&gt;
      &#123;/* Your app content */&#125;
    &lt;/&gt;
    );
    &#125;</code></pre>
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
        <h3 class="text-lg font-semibold mb-3">Toast Methods</h3>
        <div class="space-y-6">
          <div>
            <h4 class="font-mono text-sm mb-2">toast.success(message, options?)</h4>
            <p class="text-sm text-gray-600 mb-2">
              Displays a success toast notification.
            </p>
            <pre class="bg-gray-900 text-gray-100 p-3 rounded text-sm"><code>toast.success('Changes saved successfully');</code></pre>
          </div>

          <div>
            <h4 class="font-mono text-sm mb-2">toast.error(message, options?)</h4>
            <p class="text-sm text-gray-600 mb-2">
              Displays an error toast notification.
            </p>
            <pre class="bg-gray-900 text-gray-100 p-3 rounded text-sm"><code>toast.error('Failed to save changes');</code></pre>
          </div>

          <div>
            <h4 class="font-mono text-sm mb-2">toast.info(message, options?)</h4>
            <p class="text-sm text-gray-600 mb-2">
              Displays an informational toast notification.
            </p>
            <pre class="bg-gray-900 text-gray-100 p-3 rounded text-sm"><code>toast.info('Processing your request...');</code></pre>
          </div>

          <div>
            <h4 class="font-mono text-sm mb-2">toast.warning(message, options?)</h4>
            <p class="text-sm text-gray-600 mb-2">
              Displays a warning toast notification.
            </p>
            <pre class="bg-gray-900 text-gray-100 p-3 rounded text-sm"><code>toast.warning('You are approaching your quota limit');</code></pre>
          </div>

          <div>
            <h4 class="font-mono text-sm mb-2">toast.dismiss(id?)</h4>
            <p class="text-sm text-gray-600 mb-2">
              Dismisses a specific toast or all toasts.
            </p>
            <pre class="bg-gray-900 text-gray-100 p-3 rounded text-sm"><code>toast.dismiss();        // Dismiss all toasts
    toast.dismiss(toastId); // Dismiss specific toast</code></pre>
          </div>

          <div>
            <h4 class="font-mono text-sm mb-2">toast.promise(promise, messages)</h4>
            <p class="text-sm text-gray-600 mb-2">
              Shows loading/success/error toasts for a promise.
            </p>
            <pre class="bg-gray-900 text-gray-100 p-3 rounded text-sm"><code>toast.promise(
    saveData(),
    &#123;
    loading: 'Saving changes...',
    success: 'Changes saved successfully',
    error: 'Failed to save changes'
    &#125;
    );</code></pre>
          </div>
        </div>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Toast Options</h3>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                  Option
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
                <td class="px-3 py-4 text-sm font-mono text-gray-900">duration</td>
                <td class="px-3 py-4 text-sm text-gray-700">number</td>
                <td class="px-3 py-4 text-sm text-gray-700">4000</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Duration in milliseconds
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">id</td>
                <td class="px-3 py-4 text-sm text-gray-700">string</td>
                <td class="px-3 py-4 text-sm text-gray-700">auto</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Toast identifier for dismissal
                </td>
              </tr>
              <tr>
                <td class="px-3 py-4 text-sm font-mono text-gray-900">
                  dismissible
                </td>
                <td class="px-3 py-4 text-sm text-gray-700">boolean</td>
                <td class="px-3 py-4 text-sm text-gray-700">true</td>
                <td class="px-3 py-4 text-sm text-gray-700">
                  Can be dismissed by user
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
        <h3 class="text-lg font-semibold mb-3">Basic Toasts</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">import &#123; toast &#125; from '@/design-system/components/toast';

    // Success toast
    toast.success('Workflow saved successfully');

    // Error toast
    toast.error('Failed to connect to server');

    // Info toast
    toast.info('Synchronizing data...');

    // Warning toast
    toast.warning('You have unsaved changes');</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Custom Duration</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">// Show for 10 seconds
    toast.success('Operation completed', &#123; duration: 10000 &#125;);

    // Show indefinitely (must be manually dismissed)
    toast.info('Important message', &#123; duration: Infinity &#125;);</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Promise-based Toasts</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">async function saveWorkflow(data) &#123;
    const promise = fetch('/api/workflows', &#123;
    method: 'POST',
    body: JSON.stringify(data)
    &#125;);

    toast.promise(promise, &#123;
    loading: 'Saving workflow...',
    success: 'Workflow saved successfully',
    error: 'Failed to save workflow'
    &#125;);
    &#125;</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Dynamic Messages</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">toast.promise(
    deleteWorkflow(id),
    &#123;
    loading: 'Deleting workflow...',
    success: (data) =&gt; `Deleted workflow "$&#123;data.name&#125;"`,
    error: (err) =&gt; `Error: $&#123;err.message&#125;`
    &#125;
    );</code></pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Dismissing Toasts</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto"><code class="text-sm">// Save toast ID for later dismissal
    const toastId = toast.info('Processing...', &#123; duration: Infinity &#125;);

    // Later, dismiss this specific toast
    setTimeout(() =&gt; &#123;
    toast.dismiss(toastId);
    toast.success('Processing complete');
    &#125;, 5000);

    // Or dismiss all toasts
    toast.dismiss();</code></pre>
      </div>
    </div>
    """
  end
end
