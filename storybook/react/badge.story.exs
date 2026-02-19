defmodule LightningWeb.Storybook.React.Badge do
  alias LightningWeb.Components.ReactComponents
  use PhoenixStorybook.Story, :component

  def function, do: &ReactComponents.badge/1

  def variations do
    [
      %Variation{
        id: :gray,
        description: "Gray badge (default)",
        attributes: %{variant: "gray"},
        slots: ["Default"]
      },
      %Variation{
        id: :red,
        description: "Red badge (danger)",
        attributes: %{variant: "red"},
        slots: ["Error"]
      },
      %Variation{
        id: :yellow,
        description: "Yellow badge (warning)",
        attributes: %{variant: "yellow"},
        slots: ["Warning"]
      },
      %Variation{
        id: :green,
        description: "Green badge (success)",
        attributes: %{variant: "green"},
        slots: ["Success"]
      },
      %Variation{
        id: :blue,
        description: "Blue badge (info)",
        attributes: %{variant: "blue"},
        slots: ["Info"]
      },
      %Variation{
        id: :indigo,
        description: "Indigo badge (primary)",
        attributes: %{variant: "indigo"},
        slots: ["Active"]
      },
      %Variation{
        id: :closeable,
        description: "Badge with close button",
        attributes: %{variant: "gray", on_close: "close"},
        slots: ["Removable"]
      }
    ]
  end
end
