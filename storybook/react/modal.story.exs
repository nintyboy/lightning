defmodule LightningWeb.Storybook.React.Modal do
  use PhoenixStorybook.Story, :page

  def doc, do: "Modal component examples"

  def navigation do
    [
      {:overview, "Overview", {:fa, "eye", :regular}}
    ]
  end

  def render(assigns = %{tab: :overview}) do
    ~H"""
    <div class="p-8 space-y-8">
      <div>
        <h2 class="text-2xl font-bold mb-4">Modal Component</h2>
        <p class="text-gray-600 mb-4">
          The Modal component is a React component that provides portal-rendered dialogs with backdrop support.
          It is designed for use in React applications, not directly in HEEx templates.
        </p>
      </div>

      <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <h3 class="font-semibold text-blue-900 mb-2">React Component Only</h3>
        <p class="text-blue-800 text-sm">
          The Modal component is a React component and cannot be rendered directly in PhoenixStorybook.
          It must be used within a React application context.
        </p>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Usage Example</h3>
        <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto">
          <code class="text-sm">
    import { Modal } from '@/design-system/components/modal';

    function MyComponent() {
    const [isOpen, setIsOpen] = useState(false);

    return (
    <>
      &lt;button onClick={() => setIsOpen(true)}&gt;Open Modal&lt;/button&gt;
      &lt;Modal isOpen={isOpen} onClose={() => setIsOpen(false)} title="My Modal"&gt;
        &lt;p&gt;Modal content goes here&lt;/p&gt;
      &lt;/Modal&gt;
    </>
    );
    }
          </code>
        </pre>
      </div>

      <div>
        <h3 class="text-lg font-semibold mb-3">Features</h3>
        <ul class="list-disc list-inside space-y-2 text-gray-700">
          <li>Portal rendering to document.body</li>
          <li>Size variants: sm, md, lg, xl</li>
          <li>Keyboard (Escape) to close</li>
          <li>Backdrop click to close</li>
          <li>Optional close button</li>
          <li>Accessibility attributes (ARIA)</li>
        </ul>
      </div>
    </div>
    """
  end
end
