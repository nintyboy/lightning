defmodule LightningWeb.Components.ReactComponents do
  @moduledoc """
  React component wrappers for Phoenix LiveView.

  This module provides Phoenix component wrappers that render React components
  from the design system. These components integrate with the existing
  React.Component pattern and can be used in HEEx templates.

  The React components are defined in `/assets/js/design-system/` and are
  built using ESBuild with entry points automatically generated from the
  `jsx/1` macro.

  ## Example

      <.button variant="primary" size="md">
        Click me
      </.button>

  """
  use Phoenix.Component

  import LightningWeb.Components.NewInputs,
    only: [simple_button_with_tooltip: 1, input: 1]

  @doc """
  Renders a React button component.

  ## Attributes

    * `:variant` - The theme variant. Values: "primary", "secondary", "danger", "success", "warning", "custom"
    * `:size` - The size variant. Values: "sm", "md", "lg"
    * `:tooltip` - A tooltip to display when the button is disabled
    * `:disabled` - Whether the button is disabled
    * `:type` - The button type. Values: "button", "submit"

  ## Slots

    * `:inner_block` (required) - The content to render inside the button

  ## Examples

      <.button variant="primary">Primary Button</.button>
      <.button variant="danger" size="sm">Delete</.button>
      <.button disabled tooltip="Cannot save right now">Save</.button>

  """
  attr :variant, :string,
    default: "primary",
    values: ["primary", "secondary", "danger", "success", "warning", "custom"]

  attr :size, :string, default: "md", values: ["sm", "md", "lg"]
  attr :tooltip, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :type, :string, default: "button", values: ["button", "submit"]
  attr :rest, :global, include: ~w(id form name value class)
  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <.simple_button_with_tooltip
      tooltip={@tooltip}
      type={@type}
      class={
        [
          # Base classes
          button_base_classes(),
          "cursor-pointer disabled:cursor-auto",
          # size variants
          button_size_classes(@size),
          # theme variants
          button_theme_classes(@variant, @disabled),
          # other classes to override
          assigns[:class]
        ]
      }
      {assigns.rest}
    >
      {render_slot(@inner_block)}
    </.simple_button_with_tooltip>
    """
  end

  defp button_base_classes do
    "rounded-md text-sm font-semibold shadow-xs phx-submit-loading:opacity-75"
  end

  defp button_size_classes("sm"), do: "px-2.5 py-1.5"
  defp button_size_classes("md"), do: "px-3 py-2"
  defp button_size_classes("lg"), do: "px-3.5 py-2.5"

  defp button_theme_classes(theme, disabled) do
    button_themes = %{
      "primary" => %{
        disabled: "bg-primary-300 text-white",
        enabled:
          "bg-primary-600 hover:bg-primary-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-600"
      },
      "secondary" => %{
        disabled: "bg-gray-50 text-gray-400 ring-1 ring-gray-200 ring-inset",
        enabled:
          "bg-white hover:bg-gray-50 text-gray-900 ring-1 ring-gray-300 ring-inset"
      },
      "danger" => %{
        disabled: "bg-red-300 text-white",
        enabled:
          "bg-red-600 hover:bg-red-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-red-600"
      },
      "success" => %{
        disabled: "bg-green-300 text-white",
        enabled:
          "bg-green-600 hover:bg-green-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-green-600"
      },
      "warning" => %{
        disabled: "bg-yellow-300 text-white",
        enabled:
          "bg-yellow-600 hover:bg-yellow-500 text-white focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-yellow-600"
      },
      "custom" => %{
        disabled: "",
        enabled: ""
      }
    }

    state = if disabled, do: :disabled, else: :enabled
    get_in(button_themes, [theme, state]) || ""
  end

  @doc """
  Renders a React badge component.

  ## Attributes

    * `:variant` - The color variant. Values: "gray", "red", "yellow", "green", "blue", "indigo"
    * `:on_close` - Optional function to call when close button is clicked

  ## Slots

    * `:inner_block` (required) - The content to render inside the badge

  ## Examples

      <.badge variant="success">Active</.badge>
      <.badge variant="danger">Failed</.badge>

  """
  attr :variant, :string,
    default: "gray",
    values: ["gray", "red", "yellow", "green", "blue", "indigo"]

  attr :on_close, :string, default: nil
  attr :rest, :global, include: ~w(id class phx_click)
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <div
      class={[
        "inline-flex items-center gap-x-1",
        "rounded-md px-2 py-1 text-xs font-medium",
        badge_bg_class(@variant),
        badge_text_class(@variant),
        @on_close && "pr-1",
        assigns[:class]
      ]}
      {@rest}
    >
      <span class="flex items-center">{render_slot(@inner_block)}</span>
      <button
        :if={@on_close}
        type="button"
        phx-click={@on_close}
        class={[
          "group relative -mr-1 flex items-center justify-center h-3.5 w-3.5 rounded-sm",
          badge_hover_class(@variant)
        ]}
        aria-label="Remove"
        title="Remove"
      >
        <span class="sr-only">Remove</span>
        <span class="hero-x-mark h-3.5 w-3.5" />
      </button>
    </div>
    """
  end

  defp badge_bg_class("gray"), do: "bg-gray-100"
  defp badge_bg_class("red"), do: "bg-red-100"
  defp badge_bg_class("yellow"), do: "bg-yellow-100"
  defp badge_bg_class("green"), do: "bg-green-100"
  defp badge_bg_class("blue"), do: "bg-blue-100"
  defp badge_bg_class("indigo"), do: "bg-indigo-100"

  defp badge_text_class("gray"), do: "text-gray-700"
  defp badge_text_class("red"), do: "text-red-700"
  defp badge_text_class("yellow"), do: "text-yellow-800"
  defp badge_text_class("green"), do: "text-green-700"
  defp badge_text_class("blue"), do: "text-blue-700"
  defp badge_text_class("indigo"), do: "text-indigo-700"

  defp badge_hover_class("gray"), do: "hover:bg-gray-200"
  defp badge_hover_class("red"), do: "hover:bg-red-200"
  defp badge_hover_class("yellow"), do: "hover:bg-yellow-200"
  defp badge_hover_class("green"), do: "hover:bg-green-200"
  defp badge_hover_class("blue"), do: "hover:bg-blue-200"
  defp badge_hover_class("indigo"), do: "hover:bg-indigo-200"

  @doc """
  Renders an input field component.
  Delegates to NewInputs.input/1 for full functionality.

  ## Examples

      <.input_field name="email" type="email" label="Email" required />

  """
  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :type, :string, default: "text"
  attr :label, :string, default: nil
  attr :sublabel, :string, default: nil
  attr :placeholder, :string, default: nil
  attr :value, :string, default: nil
  attr :required, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :help_text, :string, default: nil

  attr :rest, :global,
    include: ~w(autocomplete maxlength minlength pattern readonly step min max)

  slot :inner_block

  def input_field(assigns) do
    ~H"""
    <div>
      <.input
        id={@id}
        name={@name}
        type={@type}
        label={@label}
        sublabel={@sublabel}
        placeholder={@placeholder}
        value={@value}
        required={@required}
        disabled={@disabled}
        {@rest}
      >
        {render_slot(@inner_block)}
      </.input>
      <p :if={@help_text && !@disabled} class="mt-1 text-xs text-gray-500">
        {@help_text}
      </p>
    </div>
    """
  end

  @doc """
  Renders a select component.
  Delegates to NewInputs.input/1 with type="select".

  ## Examples

      <.select name="status" label="Status" options={[{"Active", "active"}, {"Inactive", "inactive"}]} />

  """
  attr :id, :string, default: nil
  attr :name, :string, required: true
  attr :label, :string, default: nil
  attr :prompt, :string, default: nil
  attr :required, :boolean, default: false
  attr :options, :list, required: true
  attr :disabled, :boolean, default: false
  attr :rest, :global, include: ~w(multiple)

  def select(assigns) do
    ~H"""
    <.input
      id={@id}
      name={@name}
      type="select"
      label={@label}
      prompt={@prompt}
      required={@required}
      options={@options}
      disabled={@disabled}
      {@rest}
    />
    """
  end
end
