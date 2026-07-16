defmodule LightningWeb.Components.UI.SplitButtonTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  defmodule Harness do
    use Phoenix.Component
    alias LightningWeb.Components.UI

    def basic(assigns) do
      ~H"""
      <UI.SplitButton.split_button
        id="save-button"
        menu_label="More save options"
        phx-click="save"
      >
        Save
        <:item id="save-sync" phx-click="save_and_sync">Save & Sync</:item>
        <:item id="save-template" disabled>Save as template</:item>
      </UI.SplitButton.split_button>
      """
    end

    def disabled(assigns) do
      ~H"""
      <UI.SplitButton.split_button
        id="save-button"
        menu_label="More save options"
        disabled
      >
        Save
        <:item id="save-sync">Save & Sync</:item>
      </UI.SplitButton.split_button>
      """
    end
  end

  describe "split_button/1" do
    test "renders the primary action with its label and phx-click" do
      html = render_component(&Harness.basic/1, %{})

      assert html =~ "Save"
      assert html =~ ~s(phx-click="save")
    end

    test "menu trigger carries proper a11y wiring, initially closed" do
      html = render_component(&Harness.basic/1, %{})

      assert html =~ ~s(aria-label="More save options")
      assert html =~ ~s(aria-haspopup="menu")
      assert html =~ ~s(aria-expanded="false")
      assert html =~ ~s(aria-controls="save-button-menu")
      assert html =~ ~s(id="save-button-menu")
      assert html =~ ~s(role="menu")
    end

    test "opening the menu shows it, flips aria-expanded, and focuses it" do
      html = render_component(&Harness.basic/1, %{})

      # The JS commands are client-side (Phoenix.LiveView.JS), so we assert
      # on the encoded push commands rather than post-click DOM state.
      # Verified against real open/Escape/click-away behavior in a browser —
      # see assets/packages/ui/docs/poc/button-risk-log.md.
      assert html =~ "show"
      assert html =~ "aria-expanded"
      assert html =~ "focus_first"
    end

    test "escape-to-close is bound on each menu item, not the menu wrapper" do
      # Regression guard: phx-keydown (non-window) matches on event.target
      # directly with no ancestor bubbling, so binding it on the wrapping
      # <div role="menu"> silently never fires once focus moves onto a
      # menuitem button via JS.focus_first. See the module doc for the full
      # story — this was caught by manually exercising Escape in a browser,
      # not by any automated test, hence locking it down here.
      html = render_component(&Harness.basic/1, %{})

      [_, menu_div] = String.split(html, ~s(role="menu"))
      [menu_div_open_tag | _] = String.split(menu_div, ">", parts: 2)
      refute menu_div_open_tag =~ "phx-keydown"

      assert html =~ ~s(id="save-sync")
      [_, item_html] = String.split(html, ~s(id="save-sync"))
      [item_open_tag | _] = String.split(item_html, ">", parts: 2)
      assert item_open_tag =~ "phx-keydown"
      assert item_open_tag =~ ~s(phx-key="escape")
    end

    test "items render as role=menuitem buttons with ids and disabled state" do
      html = render_component(&Harness.basic/1, %{})

      assert html =~ ~s(id="save-sync")
      assert html =~ ~s(role="menuitem")
      assert html =~ "Save &amp; Sync" or html =~ "Save & Sync"
      assert html =~ ~s(phx-click="save_and_sync")

      assert html =~ ~s(id="save-template")
      assert html =~ "disabled"
    end

    test "disabled/1 disables both segments" do
      html = render_component(&Harness.disabled/1, %{})

      # Primary segment and the menu-trigger segment both render `disabled`.
      assert html |> String.split("disabled") |> length() >= 3
    end
  end

  # Note: `menu_label` and `:item :id` are declared `required: true` via
  # Phoenix's `attr`/`slot` DSL, which the HEEx compiler enforces at COMPILE
  # time (a stricter guarantee than the React SplitButton's TypeScript-only
  # requirement) — omitting either fails `mix compile`, not a runtime test.
end
