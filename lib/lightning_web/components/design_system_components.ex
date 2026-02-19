defmodule LightningWeb.Components.DesignSystemComponents do
  @moduledoc """
  Design system components for Lightning.

  Phoenix/HEEx implementations that replicate the React design system
  components from assets/js/design-system/. These components can be used
  in LiveView templates and PhoenixStorybook.

  For React contexts (collaborative editor), use the original React
  components from the design-system package.
  """
  use Phoenix.Component

  @doc """
  Renders a button with consistent styling.

  ## Examples

      <.button variant="primary" size="md">
        Click me
      </.button>

      <.button variant="danger" disabled>
        Delete
      </.button>

  ## Attributes

  - `variant` - Color variant: :primary (default), :secondary, :danger, :success, :warning, :custom
  - `size` - Size: :sm, :md (default), :lg
  - `disabled` - Boolean, disables the button
  - `type` - Button type: "button" (default), "submit", "reset"
  - `class` - Additional CSS classes
  - `rest` - Additional HTML attributes passed to the button element
  """
  attr :variant, :atom,
    default: :primary,
    values: [:primary, :secondary, :danger, :success, :warning, :custom]

  attr :size, :atom, default: :md, values: [:sm, :md, :lg]
  attr :disabled, :boolean, default: false
  attr :type, :string, default: "button"
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      disabled={@disabled}
      class={[
        button_base_classes(),
        button_size_classes(@size),
        button_variant_classes(@variant, @disabled),
        (@disabled && "cursor-auto") || "cursor-pointer",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp button_base_classes do
    "rounded-md text-lg font-semibold shadow-xs phx-submit-loading:opacity-75 font-sans"
  end

  defp button_size_classes(:sm), do: "px-2.5 py-1.5"
  defp button_size_classes(:md), do: "px-3 py-2"
  defp button_size_classes(:lg), do: "px-3.5 py-2.5"

  defp button_variant_classes(:primary, false) do
    "bg-primary-600 hover:bg-primary-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-600"
  end

  defp button_variant_classes(:primary, true) do
    "bg-primary-300 text-white cursor-not-allowed"
  end

  defp button_variant_classes(:secondary, false) do
    "bg-white hover:bg-gray-50 text-gray-900 ring-1 ring-gray-300 ring-inset"
  end

  defp button_variant_classes(:secondary, true) do
    "bg-gray-50 text-gray-400 ring-1 ring-gray-200 ring-inset cursor-not-allowed"
  end

  defp button_variant_classes(:danger, false) do
    "bg-red-600 hover:bg-red-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-600"
  end

  defp button_variant_classes(:danger, true) do
    "bg-red-300 text-white cursor-not-allowed"
  end

  defp button_variant_classes(:success, false) do
    "bg-green-600 hover:bg-green-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-600"
  end

  defp button_variant_classes(:success, true) do
    "bg-green-300 text-white cursor-not-allowed"
  end

  defp button_variant_classes(:warning, false) do
    "bg-yellow-600 hover:bg-yellow-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-yellow-600"
  end

  defp button_variant_classes(:warning, true) do
    "bg-yellow-300 text-white cursor-not-allowed"
  end

  defp button_variant_classes(:custom, _disabled), do: ""

  @doc """
  Renders a badge for status or labels.

  ## Examples

      <.badge variant="gray">
        Default
      </.badge>

      <.badge variant="green">
        Success
      </.badge>

      <.badge variant="red" closeable phx-click="remove">
        Closeable
      </.badge>

  ## Attributes

  - `variant` - Color variant: :gray (default), :red, :yellow, :green, :blue, :indigo
  - `closeable` - Boolean, shows a close button
  - `class` - Additional CSS classes
  - `rest` - Additional HTML attributes passed to the badge element
  """
  attr :variant, :atom,
    default: :gray,
    values: [:gray, :red, :yellow, :green, :blue, :indigo]

  attr :closeable, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <div
      class={[
        "inline-flex items-center gap-x-1 rounded-md px-2 py-1 text-xs font-medium",
        badge_variant_classes(@variant),
        @closeable && "pr-1",
        @class
      ]}
      {@rest}
    >
      <span class="flex items-center">
        {render_slot(@inner_block)}
      </span>
      <%= if @closeable do %>
        <button
          type="button"
          class={[
            "group relative -mr-1 flex items-center justify-center h-3.5 w-3.5 rounded-sm",
            badge_hover_classes(@variant)
          ]}
          aria-label="Remove"
          title="Remove"
          {@rest}
        >
          <span class="sr-only">Remove</span>
          <span class="hero-x-mark h-3.5 w-3.5" />
        </button>
      <% end %>
    </div>
    """
  end

  defp badge_variant_classes(:gray), do: "bg-gray-100 text-gray-700"
  defp badge_variant_classes(:red), do: "bg-red-100 text-red-700"
  defp badge_variant_classes(:yellow), do: "bg-yellow-100 text-yellow-800"
  defp badge_variant_classes(:green), do: "bg-green-100 text-green-700"
  defp badge_variant_classes(:blue), do: "bg-blue-100 text-blue-700"
  defp badge_variant_classes(:indigo), do: "bg-indigo-100 text-indigo-700"

  defp badge_hover_classes(:gray), do: "hover:bg-gray-200"
  defp badge_hover_classes(:red), do: "hover:bg-red-200"
  defp badge_hover_classes(:yellow), do: "hover:bg-yellow-200"
  defp badge_hover_classes(:green), do: "hover:bg-green-200"
  defp badge_hover_classes(:blue), do: "hover:bg-blue-200"
  defp badge_hover_classes(:indigo), do: "hover:bg-indigo-200"

  @doc """
  Renders an icon using Heroicons via Tailwind classes.

  ## Examples

      <.icon name="hero-check-micro" />

      <.icon name="hero-exclamation-circle" size="lg" />

      <.icon name="hero-chevron-down" size="sm" class="text-gray-500" />

  ## Attributes

  - `name` - Heroicon class name (e.g., "hero-check-micro")
  - `size` - Icon size: :xs, :sm, :md (default), :lg, :xl
  - `class` - Additional CSS classes
  - `rest` - Additional HTML attributes
  """
  attr :name, :string, required: true
  attr :size, :atom, default: :md, values: [:xs, :sm, :md, :lg, :xl]
  attr :class, :string, default: nil
  attr :rest, :global

  def icon(assigns) do
    ~H"""
    <span
      class={[
        icon_size_classes(@size),
        @name,
        @class
      ]}
      aria-hidden="true"
      {@rest}
    />
    """
  end

  defp icon_size_classes(:xs), do: "h-3 w-3"
  defp icon_size_classes(:sm), do: "h-4 w-4"
  defp icon_size_classes(:md), do: "h-5 w-5"
  defp icon_size_classes(:lg), do: "h-6 w-6"
  defp icon_size_classes(:xl), do: "h-8 w-8"

  @doc """
  Renders a text input field.

  ## Examples

      <.input type="text" name="username" />

      <.input type="email" name="email" errors={["is required"]} />

      <.input type="password" name="password" disabled />

  ## Attributes

  - `type` - Input type: "text" (default), "email", "password", "number", "tel", "url", etc.
  - `errors` - List of error strings
  - `class` - Additional CSS classes
  - `rest` - Additional HTML attributes (name, value, placeholder, etc.)
  """
  attr :type, :string, default: "text"
  attr :errors, :list, default: []
  attr :class, :string, default: nil

  attr :rest, :global,
    include: ~w(disabled name value placeholder autocomplete readonly required)

  def input(assigns) do
    ~H"""
    <input
      type={@type}
      class={[
        input_base_classes(),
        input_state_classes(@errors),
        @class
      ]}
      {@rest}
    />
    """
  end

  defp input_base_classes do
    "focus:outline focus:outline-2 focus:outline-offset-1 block w-full rounded-lg text-slate-900 focus:ring-0 sm:text-sm sm:leading-6 disabled:cursor-not-allowed disabled:bg-gray-50 disabled:text-gray-500"
  end

  defp input_state_classes([]),
    do:
      "phx-no-feedback:border-slate-300 phx-no-feedback:focus:border-slate-400 border-slate-300 focus:border-slate-400 focus:outline-primary-600"

  defp input_state_classes(_errors),
    do: "border-danger-400 focus:border-danger-400 focus:outline-danger-400"

  @doc """
  Renders a complete input field with label, help text, and error messages.

  ## Examples

      <.input_field
        name="username"
        label="Username"
        required
      />

      <.input_field
        name="email"
        type="email"
        label="Email Address"
        sublabel="We'll never share your email"
        help_text="Enter a valid email address"
        errors={["is required", "must be valid"]}
      />

  ## Attributes

  - `name` - Input name attribute
  - `label` - Label text
  - `sublabel` - Secondary label text shown below the label
  - `type` - Input type (default: "text")
  - `errors` - List of error strings
  - `required` - Boolean, shows asterisk in label
  - `help_text` - Help text shown below input (hidden if errors present)
  - `class` - Additional CSS classes for the wrapper
  - `rest` - Additional HTML attributes passed to input
  """
  attr :name, :string, required: true
  attr :label, :string, default: nil
  attr :sublabel, :string, default: nil
  attr :type, :string, default: "text"
  attr :errors, :list, default: []
  attr :required, :boolean, default: false
  attr :help_text, :string, default: nil
  attr :class, :string, default: nil

  attr :rest, :global,
    include: ~w(disabled value placeholder autocomplete readonly)

  slot :inner_block

  def input_field(assigns) do
    ~H"""
    <div class={@class}>
      <%= if @label do %>
        <label for={@name} class="mb-2 text-sm/6 font-medium text-slate-800">
          {@label}
          <%= if @required do %>
            <span class="text-red-500 ml-1">*</span>
          <% end %>
        </label>
      <% end %>

      <%= if @sublabel do %>
        <small class="mb-2 block text-xs text-gray-600">{@sublabel}</small>
      <% end %>

      <div class="relative">
        <.input id={@name} name={@name} type={@type} errors={@errors} {@rest} />
        {render_slot(@inner_block)}
      </div>

      <%= if @errors != [] do %>
        <div class="mt-1 space-y-0.5">
          <%= for error <- @errors do %>
            <p
              data-tag="error_message"
              class="inline-flex items-center gap-x-1.5 text-xs text-danger-600"
            >
              <span class="hero-exclamation-circle h-4 w-4" />
              {error}
            </p>
          <% end %>
        </div>
      <% end %>

      <%= if @help_text && @errors == [] do %>
        <p class="mt-1 text-xs text-gray-500">{@help_text}</p>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a select dropdown.

  ## Examples

      <.select
        name="country"
        options={[
          %{label: "United States", value: "us"},
          %{label: "Canada", value: "ca"}
        ]}
      />

      <.select
        name="role"
        label="Role"
        prompt="Select a role"
        required
        options={[
          %{label: "Admin", value: "admin"},
          %{label: "User", value: "user"}
        ]}
        errors={["is required"]}
      />

  ## Attributes

  - `name` - Select name attribute
  - `options` - List of option maps with :label and :value keys (optional :disabled)
  - `prompt` - Placeholder option text
  - `label` - Label text
  - `required` - Boolean, shows asterisk in label
  - `errors` - List of error strings
  - `class` - Additional CSS classes
  - `rest` - Additional HTML attributes
  """
  attr :name, :string, required: true
  attr :options, :list, required: true
  attr :prompt, :string, default: nil
  attr :label, :string, default: nil
  attr :required, :boolean, default: false
  attr :errors, :list, default: []
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled value)

  def select(assigns) do
    ~H"""
    <div>
      <%= if @label do %>
        <label for={@name} class="mb-2 text-sm/6 font-medium text-slate-800">
          {@label}
          <%= if @required do %>
            <span class="text-red-500 ml-1">*</span>
          <% end %>
        </label>
      <% end %>

      <select
        id={@name}
        name={@name}
        class={[
          "block w-full rounded-lg border border-secondary-300 bg-white sm:text-sm shadow-xs focus:border-primary-300 focus:ring focus:ring-primary-200/50 disabled:cursor-not-allowed",
          @class
        ]}
        {@rest}
      >
        <%= if @prompt do %>
          <option value="">{@prompt}</option>
        <% end %>
        <%= for option <- @options do %>
          <option value={option.value} disabled={Map.get(option, :disabled, false)}>
            {option.label}
          </option>
        <% end %>
      </select>

      <%= if @errors != [] do %>
        <div class="mt-1 space-y-0.5">
          <%= for error <- @errors do %>
            <p
              data-tag="error_message"
              class="inline-flex items-center gap-x-1.5 text-xs text-danger-600"
            >
              <span class="hero-exclamation-circle h-4 w-4" />
              {error}
            </p>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
