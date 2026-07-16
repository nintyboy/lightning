defmodule LightningWeb.Components.UI.ButtonTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  defmodule Harness do
    use Phoenix.Component
    alias LightningWeb.Components.UI

    def themed(assigns) do
      assigns =
        assigns
        |> Map.put_new(:size, "md")
        |> Map.put_new(:disabled, false)
        |> Map.put_new(:icon, nil)
        |> Map.put_new(:icon_right, nil)

      ~H"""
      <UI.Button.button
        theme={@theme}
        size={@size}
        disabled={@disabled}
        icon={@icon}
        icon_right={@icon_right}
      >
        Label
      </UI.Button.button>
      """
    end

    def link(assigns) do
      assigns = Map.put_new(assigns, :disabled, false)

      ~H"""
      <UI.Button.button_link theme={@theme} disabled={@disabled} href="/x">
        Go
      </UI.Button.button_link>
      """
    end

    def with_tooltip(assigns) do
      ~H"""
      <UI.Button.button
        id="tt-button"
        theme="primary"
        disabled={true}
        tooltip="Reason it is disabled"
      >
        Label
      </UI.Button.button>
      """
    end

    def icon_only(assigns) do
      ~H"""
      <UI.Button.button
        theme="ghost"
        size="icon"
        icon="hero-x-mark"
        aria-label={@aria_label}
      />
      """
    end

    def icon_only_no_label(assigns) do
      ~H"""
      <UI.Button.button theme="ghost" size="icon" icon="hero-x-mark" />
      """
    end

    def icon_only_with_tooltip_only(assigns) do
      ~H"""
      <UI.Button.button
        theme="ghost"
        size="icon"
        icon="hero-x-mark"
        tooltip="Close this panel"
      />
      """
    end
  end

  @recipe "assets/packages/ui/recipes/button.json"
          |> File.read!()
          |> Jason.decode!()

  describe "button/1 (recipe contract)" do
    test "renders every recipe variant's enabled classes" do
      for {theme, %{"enabled" => enabled}} <- @recipe["variants"],
          enabled != "" do
        html = render_component(&Harness.themed/1, %{theme: theme})
        [first_class | _] = String.split(enabled)
        assert html =~ first_class, "theme #{theme} missing #{first_class}"
      end
    end

    test "swaps to disabled classes when disabled" do
      html =
        render_component(&Harness.themed/1, %{theme: "primary", disabled: true})

      assert html =~ "bg-primary-300"
      refute html =~ "hover:bg-primary-500"
      assert html =~ "disabled"
    end

    test "renders every recipe size" do
      for {size, classes} <- @recipe["sizes"] do
        html =
          render_component(&Harness.themed/1, %{theme: "primary", size: size})

        [first_class | _] = String.split(classes)
        assert html =~ first_class
      end
    end
  end

  describe "button/1 icons" do
    test "renders decorative left and right icons" do
      html =
        render_component(&Harness.themed/1, %{
          theme: "secondary",
          icon: "hero-plus",
          icon_right: "hero-arrow-right"
        })

      assert html =~ "hero-plus"
      assert html =~ "hero-arrow-right"
      assert html =~ ~s(aria-hidden="true")
    end

    test "renders no icon spans by default" do
      html = render_component(&Harness.themed/1, %{theme: "secondary"})
      refute html =~ "aria-hidden"
    end

    test "icon has no label-spacing margin in icon-only mode" do
      html =
        render_component(&Harness.icon_only/1, %{aria_label: "Close panel"})

      refute html =~ "mr-1.5"
      refute html =~ "-ml-0.5"
    end
  end

  describe "button/1 icon-only accessible name (i18n/a11y guard)" do
    test "renders fine with an aria-label and no visible content" do
      html =
        render_component(&Harness.icon_only/1, %{aria_label: "Close panel"})

      assert html =~ ~s(aria-label="Close panel")
      assert html =~ "hero-x-mark"
    end

    test "raises when there is no inner content and no aria-label" do
      assert_raise ArgumentError, ~r/requires an `aria-label`/, fn ->
        render_component(&Harness.icon_only_no_label/1, %{})
      end
    end

    test "a tooltip is not accepted as a substitute for aria-label" do
      assert_raise ArgumentError, ~r/requires an `aria-label`/, fn ->
        render_component(&Harness.icon_only_with_tooltip_only/1, %{})
      end
    end
  end

  describe "button/1 tooltip-when-disabled" do
    test "wraps in a Tooltip hook span only when disabled with a tooltip" do
      html = render_component(&Harness.with_tooltip/1, %{})
      assert html =~ ~s(phx-hook="Tooltip")
      assert html =~ "Reason it is disabled"

      html = render_component(&Harness.themed/1, %{theme: "primary"})
      refute html =~ ~s(phx-hook="Tooltip")
    end
  end

  describe "button_link/1" do
    test "renders an anchor when enabled and an aria-disabled span when disabled" do
      html = render_component(&Harness.link/1, %{theme: "primary"})
      assert html =~ "<a"
      assert html =~ ~s(href="/x")

      html =
        render_component(&Harness.link/1, %{theme: "primary", disabled: true})

      refute html =~ "<a"
      assert html =~ ~s(aria-disabled="true")
      assert html =~ "pointer-events-none"
    end
  end
end
