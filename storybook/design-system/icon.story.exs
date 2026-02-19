defmodule LightningWeb.Storybook.DesignSystem.Icon do
  alias LightningWeb.Components.DesignSystemComponents
  use PhoenixStorybook.Story, :component

  def function, do: &DesignSystemComponents.icon/1

  def variations do
    [
      %Variation{
        id: :check_xs,
        description: "Check icon - extra small",
        attributes: %{name: "hero-check-micro", size: :xs}
      },
      %Variation{
        id: :check_sm,
        description: "Check icon - small",
        attributes: %{name: "hero-check-micro", size: :sm}
      },
      %Variation{
        id: :check_md,
        description: "Check icon - medium (default)",
        attributes: %{name: "hero-check-micro", size: :md}
      },
      %Variation{
        id: :check_lg,
        description: "Check icon - large",
        attributes: %{name: "hero-check-micro", size: :lg}
      },
      %Variation{
        id: :check_xl,
        description: "Check icon - extra large",
        attributes: %{name: "hero-check-micro", size: :xl}
      },
      %Variation{
        id: :x_mark,
        description: "X mark icon",
        attributes: %{name: "hero-x-mark", size: :md}
      },
      %Variation{
        id: :exclamation_circle,
        description: "Exclamation circle icon",
        attributes: %{name: "hero-exclamation-circle", size: :md}
      },
      %Variation{
        id: :information_circle,
        description: "Information circle icon",
        attributes: %{name: "hero-information-circle", size: :md}
      },
      %Variation{
        id: :chevron_down,
        description: "Chevron down icon",
        attributes: %{name: "hero-chevron-down", size: :md}
      },
      %Variation{
        id: :chevron_right,
        description: "Chevron right icon",
        attributes: %{name: "hero-chevron-right", size: :md}
      },
      %Variation{
        id: :colored_icon,
        description: "Icon with custom color",
        attributes: %{
          name: "hero-check-circle",
          size: :lg,
          class: "text-green-600"
        }
      }
    ]
  end
end
