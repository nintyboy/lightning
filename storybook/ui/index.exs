defmodule Storybook.UI do
  @moduledoc false
  use PhoenixStorybook.Index

  def folder_name, do: "UI"
  def folder_icon, do: {:fa, "palette", :regular, "lsb-mr-1"}
  def folder_open?, do: true
  def folder_index, do: 9

  def entry("button") do
    [
      name: "Button",
      icon: {:fa, "square", "regular"}
    ]
  end

  def entry("button_link") do
    [
      name: "Button Link",
      icon: {:fa, "link", "regular"}
    ]
  end

  def entry("input_text") do
    [
      name: "Input - Text",
      icon: {:fa, "i-cursor", "regular"}
    ]
  end

  def entry("input_checkbox") do
    [
      name: "Input - Checkbox",
      icon: {:fa, "square-check", "regular"}
    ]
  end

  def entry("input_select") do
    [
      name: "Input - Select",
      icon: {:fa, "chevron-down", "regular"}
    ]
  end

  def entry("input_textarea") do
    [
      name: "Input - Textarea",
      icon: {:fa, "align-left", "regular"}
    ]
  end

  def entry("input_toggle") do
    [
      name: "Input - Toggle",
      icon: {:fa, "toggle-on", "regular"}
    ]
  end

  def entry("input_tag") do
    [
      name: "Input - Tag",
      icon: {:fa, "tags", "regular"}
    ]
  end
end
