defmodule LightningWeb.Components.UI.SplitButton do
  @moduledoc """
  Split button: a primary action plus an attached menu of related actions
  (design-system POC — the HEEx twin of `assets/packages/ui/src/button/SplitButton.tsx`).

  Consolidation target for the three bespoke split buttons found in the
  master inventory (collab-editor SaveButton, RunRetryButton, HEEx
  `new_credential_menu_button`).

  Built from `Phoenix.LiveView.JS` and the same `phx-click-away` /
  `role="menu"` conventions already used by
  `LightningWeb.Components.Common.simple_dropdown/1` — no custom JS hook.
  Unlike `simple_dropdown/1`, `aria-expanded` is kept in sync with the
  actual open/closed state via `JS.set_attribute/3` (that component
  hardcodes `aria-expanded="true"`, which is a pre-existing bug this
  module does not repeat), and opening the menu moves focus into it via
  `JS.focus_first/2` — the two behaviors react-aria's `MenuTrigger`
  provides automatically on the React side.

  ## Escape-to-close: why it's bound per menu item, not per menu

  Per the WAI-ARIA APG Menu Button pattern, Escape must close an open menu
  and return focus to its trigger. The obvious binding —
  `phx-keydown` + `phx-key="escape"` on the menu wrapper `<div>` — does
  NOT work: LiveView's (non-window) `phx-keydown` checks
  `event.target.getAttribute(binding)` directly with no ancestor/bubbling
  lookup (see `deps/phoenix_live_view/assets/js/phoenix_live_view/live_socket.js`,
  `bind/2`), so the div only reacts if the div itself is `document.activeElement`.
  Since `JS.focus_first` moves focus onto the first `role="menuitem"`
  button, the handler has to live on each item button instead — verified
  in a real browser (multiple split buttons on one page; opening/Escaping
  one must not steal focus from or affect any other instance).
  `phx-window-keydown` was tried first and is the wrong tool here for the
  opposite reason: it fires globally for every mounted instance regardless
  of which menu is actually open.
  """
  use Phoenix.Component

  import LightningWeb.Components.UI.Button

  alias Phoenix.LiveView.JS

  @button_themes ~w(primary secondary danger success warning ghost)
  @button_sizes ~w(sm md lg)

  @doc """
  Renders a split button.

  ## Attributes

    * `:id` - Required. Used to derive the menu and trigger element ids.
    * `:theme` - Same themes as `button/1` minus `"custom"`. Defaults to `"primary"`.
    * `:size` - Same sizes as `button/1` minus `"icon"`. Defaults to `"md"`.
    * `:menu_label` - Required. Accessible name for the menu-trigger segment
      (e.g. `gettext("More save options")`). No English default is provided —
      the caller must supply it (i18n convention for this design system).
    * `:disabled` - Disables both segments. Defaults to `false`.
    * `:rest` - Passed to the primary action segment (`phx-click`, `type`, etc).

  ## Slots

    * `:inner_block` (required) - Label for the primary action segment.
    * `:item` (required, at least one) - One menu item, matching the React
      `SplitButtonItem` shape (`{id, label, onAction, isDisabled}`): `:id`
      (required), `:disabled`, `:"phx-click"`, `:"phx-target"`. The slot's
      inner content is the item's label (`label`/`onAction`'s HEEx
      equivalent) — no default text.

  ## Example

  ```heex
  <.split_button id="save-button" menu_label={gettext("More save options")} phx-click="save">
    {gettext("Save")}
    <:item id="save-sync" phx-click="save_and_sync">{gettext("Save & Sync")}</:item>
    <:item id="save-template" disabled>{gettext("Save as template")}</:item>
  </.split_button>
  ```
  """
  attr :id, :string, required: true
  attr :theme, :string, default: "primary", values: @button_themes
  attr :size, :string, default: "md", values: @button_sizes
  attr :menu_label, :string, required: true
  attr :disabled, :boolean, default: false
  attr :rest, :global, include: ~w(type form name value)

  slot :inner_block, required: true

  # Mirrors the React SplitButtonItem interface exactly ({id, label, onAction,
  # isDisabled}) rather than an arbitrary-props bag — `:global` slot attrs
  # aren't supported by this LiveView version, but the React shape is
  # already this narrow, so declaring the same fixed fields is true parity,
  # not a workaround.
  slot :item, required: true do
    attr :id, :string, required: true
    attr :disabled, :boolean
    attr :"phx-click", :any
    attr :"phx-target", :any
  end

  def split_button(assigns) do
    menu_id = "#{assigns.id}-menu"
    trigger_id = "#{assigns.id}-trigger"

    assigns = assign(assigns, menu_id: menu_id, trigger_id: trigger_id)

    ~H"""
    <div id={@id} class="relative inline-flex">
      <.button
        theme={@theme}
        size={@size}
        disabled={@disabled}
        class="rounded-r-none focus-visible:z-10"
        {@rest}
      >
        {render_slot(@inner_block)}
      </.button>
      <.button
        id={@trigger_id}
        type="button"
        theme={@theme}
        size={@size}
        disabled={@disabled}
        icon="hero-chevron-down"
        aria-label={@menu_label}
        aria-haspopup="menu"
        aria-expanded="false"
        aria-controls={@menu_id}
        class="rounded-l-none -ml-px px-1.5 focus-visible:z-10"
        phx-click={open_menu(@menu_id, @trigger_id)}
      />
      <div
        id={@menu_id}
        role="menu"
        aria-orientation="vertical"
        tabindex="-1"
        class="hidden absolute right-0 top-full z-40 mt-1 min-w-40 origin-top-right rounded-md bg-white py-1 text-sm text-gray-700 shadow-lg ring-1 ring-black/5 focus:outline-none"
        phx-click-away={close_menu(@menu_id, @trigger_id)}
      >
        <button
          :for={item <- @item}
          type="button"
          id={item.id}
          role="menuitem"
          disabled={item[:disabled] || false}
          class="block w-full px-4 py-2 text-left cursor-pointer hover:bg-gray-100 disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:bg-transparent"
          phx-click={item[:"phx-click"]}
          phx-target={item[:"phx-target"]}
          phx-keydown={close_menu(@menu_id, @trigger_id)}
          phx-key="escape"
        >
          {render_slot(item)}
        </button>
      </div>
    </div>
    """
  end

  defp open_menu(menu_id, trigger_id) do
    %JS{}
    |> JS.show(to: "##{menu_id}")
    |> JS.set_attribute({"aria-expanded", "true"}, to: "##{trigger_id}")
    |> JS.focus_first(to: "##{menu_id}")
  end

  defp close_menu(menu_id, trigger_id) do
    %JS{}
    |> JS.hide(to: "##{menu_id}")
    |> JS.set_attribute({"aria-expanded", "false"}, to: "##{trigger_id}")
    |> JS.focus(to: "##{trigger_id}")
  end
end
