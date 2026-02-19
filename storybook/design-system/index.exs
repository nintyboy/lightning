defmodule Storybook.DesignSystem do
  @moduledoc false
  use PhoenixStorybook.Index

  def folder_name, do: "Design System"
  def folder_icon, do: {:fa, "palette", :regular, "lsb-mr-1"}
  def folder_open?, do: true
  def folder_index, do: 9

  def entry("button") do
    [
      name: "Button",
      icon: {:fa, "square", "regular"}
    ]
  end

  def entry("badge") do
    [
      name: "Badge",
      icon: {:fa, "tag", "regular"}
    ]
  end

  def entry("icon") do
    [
      name: "Icon",
      icon: {:fa, "icons", "regular"}
    ]
  end

  def entry("input") do
    [
      name: "Input",
      icon: {:fa, "i-cursor", "regular"}
    ]
  end

  def entry("input_field") do
    [
      name: "InputField",
      icon: {:fa, "rectangle-list", "regular"}
    ]
  end

  def entry("select") do
    [
      name: "Select",
      icon: {:fa, "chevron-down", "regular"}
    ]
  end

  def entry("modal") do
    [
      name: "Modal",
      icon: {:fa, "window-maximize", "regular"}
    ]
  end

  def entry("toast") do
    [
      name: "Toast",
      icon: {:fa, "bell", "regular"}
    ]
  end

  def entry("sidebar") do
    [
      name: "Sidebar",
      icon: {:fa, "sidebar", "regular"}
    ]
  end
end
