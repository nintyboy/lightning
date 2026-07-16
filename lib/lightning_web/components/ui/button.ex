defmodule LightningWeb.Components.UI.Button do
  @moduledoc """
  The canonical button component (design-system POC).

  Styling is read at compile time from the shared class recipe at
  `assets/packages/ui/recipes/button.json`, which the React button
  (`assets/js/collaborative-editor/components/Button.tsx`) also consumes,
  keeping the two stacks visually in lockstep. Editing the recipe
  recompiles this module (`@external_resource`).

  Moved from `LightningWeb.Components.NewInputs` with an unchanged public
  API: `button/1`, `button_link/1` and `simple_button_with_tooltip/1`.
  """
  use Phoenix.Component

  @recipe_path Path.expand(
                 "../../../../assets/packages/ui/recipes/button.json",
                 __DIR__
               )
  @external_resource @recipe_path
  @recipe @recipe_path |> File.read!() |> Jason.decode!()

  @button_themes ~w(primary secondary danger success warning ghost custom)
  @button_sizes ~w(sm md lg icon)

  # Compile-time guard: the recipe and the attr values must agree.
  unless Enum.sort(@button_themes) == Enum.sort(Map.keys(@recipe["variants"])) do
    raise "button.json variants #{inspect(Map.keys(@recipe["variants"]))} " <>
            "do not match @button_themes #{inspect(@button_themes)}"
  end

  unless Enum.sort(@button_sizes) == Enum.sort(Map.keys(@recipe["sizes"])) do
    raise "button.json sizes do not match @button_sizes"
  end

  @doc """
  Renders a button.

  ## Attributes

    * `:type` - The type of the button. Defaults to `"button"`. Acceptable values are:
      * `"button"`
      * `"submit"`

    * `:class` - Additional CSS classes to apply to the button. Defaults to an empty string.

    * `:theme` - The theme of the button. Acceptable values are:
      * `"primary"`
      * `"secondary"`
      * `"danger"`
      * `"success"`
      * `"warning"`
      * `"ghost"`
      * `"custom"`

    * `:size` - The padding size of the button. Defaults to `"md"`. Acceptable values are:
      * `"sm"` - Small
      * `"md"` - Medium
      * `"lg"` - Large
      * `"icon"` - Square padding for icon-only buttons

    * `:tooltip` - A tooltip to display when the button is disabled. Defaults to `nil`.
      Supplementary only — never a substitute for `aria-label` on icon-only buttons
      (tooltip content isn't reliably exposed as the accessible name to screen readers).

    * `:rest` - Any additional global attributes (e.g., `id`, `disabled`, `form`, `name`,
      `value`, `aria-label`) that should be applied to the button.

  ## Slots

    * `:inner_block` - The content to render inside the button. Optional for
      icon-only buttons (see below), otherwise the visible label.

  ## Examples

  Basic button:

  ```heex
  <.button theme="primary">Click me</.button>
  ```

  Button with a click event:

  ```heex
  <.button theme="primary" phx-click="submit_form">Submit</.button>
  ```

  Button with a size:

  ```heex
  <.button theme="secondary" size="sm">Small Button</.button>
  ```

  Button with a tooltip (visible when disabled):

  ```heex
  <.button theme="primary" disabled={true} tooltip="You cannot click this button right now">
    Disabled Button
  </.button>
  ```

  Icon-only button — an `aria-label` is REQUIRED (i18n: the caller supplies the
  string; no English default is provided anywhere in this component):

  ```heex
  <.button theme="ghost" size="icon" icon="hero-x-mark" aria-label={gettext("Close")} />
  ```

  ## Notes

    * The `theme` attribute applies predefined styles from the shared recipe. The
      `"custom"` theme applies no theme-specific styles, allowing full customization
      via `:class`.
    * A button without a `theme` renders unstyled apart from `:class` (pre-existing
      behavior, kept for API stability).
    * Icon-only usage (no `:inner_block` content) raises at render time unless
      `aria-label` is supplied — mirrors the React Button's type-level requirement,
      enforced here at runtime since HEEx has no static discriminated-union check.
  """
  attr :type, :string, default: "button", values: ["button", "submit"]
  attr :class, :any, default: ""
  attr :theme, :string, values: @button_themes
  attr :size, :string, default: "md", values: @button_sizes
  attr :tooltip, :any, default: nil

  attr :icon, :string,
    default: nil,
    doc: "hero-* icon class rendered before the label (decorative)"

  attr :icon_right, :string,
    default: nil,
    doc: "hero-* icon class rendered after the label (decorative)"

  attr :rest, :global, include: ~w(id disabled form name value)

  slot :inner_block

  def button(%{theme: theme} = assigns) when is_binary(theme) do
    disabled = assigns[:rest][:disabled] || false

    assigns
    |> assign(:class, [
      # Base classes
      button_base_classes(),
      "cursor-pointer disabled:cursor-auto",
      # size variants
      button_size_classes(assigns.size),
      # theme variants
      button_theme_classes(theme, disabled),
      # other classes to override
      assigns.class
    ])
    |> assign(theme: nil)
    |> button()
  end

  def button(assigns) do
    assigns = assign(assigns, :has_label?, assigns.inner_block != [])

    unless assigns.has_label? or Map.has_key?(assigns.rest, :"aria-label") do
      raise ArgumentError, """
      <.button> with no inner content (icon-only) requires an `aria-label` \
      so the button has an accessible name. Pass caller-supplied text, e.g.:

          <.button theme="ghost" size="icon" icon="hero-x-mark" aria-label={gettext("Close")} />

      This component intentionally ships no English default strings.
      """
    end

    ~H"""
    <.simple_button_with_tooltip
      tooltip={@tooltip}
      type={@type}
      class={@class}
      {@rest}
    >
      <span
        :if={@icon}
        class={[
          @icon,
          "size-4 self-center",
          @has_label? && "mr-1.5 -ml-0.5"
        ]}
        aria-hidden="true"
      />
      {render_slot(@inner_block)}
      <span
        :if={@icon_right}
        class={[
          @icon_right,
          "size-4 self-center",
          @has_label? && "ml-1.5 -mr-0.5"
        ]}
        aria-hidden="true"
      />
    </.simple_button_with_tooltip>
    """
  end

  @doc """
  Renders a link, styled like a button.

  For available options, see `Phoenix.Component.link/1`.
  """
  attr :class, :any, default: ""
  attr :theme, :string, values: @button_themes, required: true
  attr :size, :string, default: "md", values: @button_sizes

  attr :disabled, :boolean,
    default: false,
    doc: "If true, renders a disabled button that cannot be clicked"

  attr :rest, :global,
    include:
      ~w(id href patch navigate replace method csrf_token download hreflang referrerpolicy rel target type)

  slot :inner_block, required: true

  def button_link(assigns) do
    ~H"""
    <%= if @disabled do %>
      <span
        class={
          [
            # Base classes
            button_base_classes(),
            "inline-block",
            # size variants
            button_size_classes(@size),
            # theme variants
            button_theme_classes(@theme, true),
            # disabled state
            "pointer-events-none cursor-not-allowed",
            # other classes to override
            @class
          ]
        }
        aria-disabled="true"
      >
        {render_slot(@inner_block)}
      </span>
    <% else %>
      <.link
        class={
          [
            # Base classes
            button_base_classes(),
            # TODO: consider another approach:
            # https://github.com/OpenFn/lightning/issues/3269
            # We want a way to style these links as buttons without interfering
            # with JS.show()—using `inline-block` leads to a Tailwind gotcha.
            "inline-block",
            # size variants
            button_size_classes(@size),
            # theme variants
            button_theme_classes(@theme, false),
            # other classes to override
            @class
          ]
        }
        {@rest}
      >
        {render_slot(@inner_block)}
      </.link>
    <% end %>
    """
  end

  defp button_base_classes, do: @recipe["base"]

  for {size, classes} <- @recipe["sizes"] do
    defp button_size_classes(unquote(size)), do: unquote(classes)
  end

  for {theme, %{"enabled" => enabled, "disabled" => disabled}} <-
        @recipe["variants"] do
    defp button_theme_classes(unquote(theme), false), do: unquote(enabled)
    defp button_theme_classes(unquote(theme), _disabled), do: unquote(disabled)
  end

  defp button_theme_classes(_theme, _disabled), do: ""

  attr :tooltip, :any, default: nil
  attr :rest, :global, include: ~w(id disabled form name value class type)

  slot :inner_block, required: true

  def simple_button_with_tooltip(assigns) do
    ~H"""
    <.tooltip_when_disabled
      id={@rest[:id]}
      tooltip={@tooltip}
      disabled={@rest[:disabled]}
    >
      <button {@rest}>
        {render_slot(@inner_block)}
      </button>
    </.tooltip_when_disabled>
    """
  end

  attr :id, :string, required: true
  attr :tooltip, :string, default: nil
  attr :disabled, :boolean, default: false
  slot :inner_block, required: true

  defp tooltip_when_disabled(%{disabled: true, tooltip: tooltip} = assigns)
       when not is_nil(tooltip) do
    ~H"""
    <span
      id={"#{@id}-tooltip"}
      phx-hook="Tooltip"
      aria-label={@tooltip}
      data-allow-html="true"
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp tooltip_when_disabled(assigns) do
    ~H"""
    {render_slot(@inner_block)}
    """
  end
end
