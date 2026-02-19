defmodule LightningWeb.Storybook.React.Toast do
  use PhoenixStorybook.Story, :page

  def doc, do: "Toast notification component"

  def navigation do
    [
      {:overview, "Overview", {:fa, "eye", :regular}}
    ]
  end

  def render(assigns = %{tab: :overview}) do
    ~H"""
    <div class="p-8 space-y-8">
      <div>
        <h2 class="text-2xl font-bold mb-4">Toast Component</h2>
        <p class="text-gray-600 mb-4">
          The Toast component extends Sonner with typed variants for consistent notification styling.
          It provides a simple API for showing toast notifications in React applications.
        </p>
      </div>

      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <h3 class="font-semibold text-blue-900 mb-2">React Component Only</h3>
        <p class="text-blue-800 text-sm">
          The Toast component is a React wrapper around Sonner and cannot be rendered directly in PhoenixStorybook.
        </p>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Usage Example</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto">
          <code class="text-sm">
    import { toast, Toaster } from '@/design-system/components/to';

    function App() {
    return (
    &lt;&gt;
      &lt;Toaster /&gt;
      &lt;button onClick={() => toast.success('Saved successfully')}&gt;
        Show Success Toast
      &lt;/button&gt;
    &lt;/&gt;
    );
    }
          </code>
        </pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">API Methods</h3>
        <ul class="list-disc list-inside space-y-2 text-gray-700">
          <li>
            <code class="bg-gray-100 px-2 py-1 rounded">toast.success(message)</code>
          </li>
          <li>
            <code class="bg-gray-100 px-2 py-1 rounded">toast.error(message)</code>
          </li>
          <li>
            <code class="bg-gray-100 px-2 py-1 rounded">toast.info(message)</code>
          </li>
          <li>
            <code class="bg-gray-100 px-2 py-1 rounded">toast.warning(message)</code>
          </li>
          <li>
            <code class="bg-gray-100 px-2 py-1 rounded">
              toast.promise(promise, messages)
            </code>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
