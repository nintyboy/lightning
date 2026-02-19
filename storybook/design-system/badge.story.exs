defmodule LightningWeb.Storybook.DesignSystem.Badge do
  alias LightningWeb.Components.DesignSystemComponents
  use PhoenixStorybook.Story, :component

  def function, do: &DesignSystemComponents.badge/1

  def variations do
    [
      %Variation{
        id: :gray,
        description: "Gray badge (default/neutral)",
        attributes: %{variant: :gray},
        slots: ["Default"]
      },
      %Variation{
        id: :red,
        description: "Red badge (danger/error)",
        attributes: %{variant: :red},
        slots: ["Error"]
      },
      %Variation{
        id: :yellow,
        description: "Yellow badge (warning)",
        attributes: %{variant: :yellow},
        slots: ["Warning"]
      },
      %Variation{
        id: :green,
        description: "Green badge (success)",
        attributes: %{variant: :green},
        slots: ["Success"]
      },
      %Variation{
        id: :blue,
        description: "Blue badge (info)",
        attributes: %{variant: :blue},
        slots: ["Info"]
      },
      %Variation{
        id: :indigo,
        description: "Indigo badge (primary/active)",
        attributes: %{variant: :indigo},
        slots: ["Active"]
      },
      %Variation{
        id: :closeable_gray,
        description: "Closeable gray badge with remove button",
        attributes: %{variant: :gray, closeable: true},
        slots: ["Removable"]
      },
      %Variation{
        id: :closeable_green,
        description: "Closeable green badge",
        attributes: %{variant: :green, closeable: true},
        slots: ["Success Tag"]
      },
      %Variation{
        id: :closeable_red,
        description: "Closeable red badge",
        attributes: %{variant: :red, closeable: true},
        slots: ["Error Tag"]
      }
    ]
  end
end
