defmodule Storybook.React do
  @moduledoc false
  use PhoenixStorybook.Index

  def folder_name, do: "React Components"
  def folder_icon, do: {:fa, "react", :brands, "lsb-mr-1"}
  def folder_open?, do: true
  def folder_index, do: 10

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

  def entry("input") do
    [
      name: "Input",
      icon: {:fa, "i-cursor", "regular"}
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
end
