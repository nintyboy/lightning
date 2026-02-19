defmodule LightningWeb.Storybook.DesignSystem.Button do
  alias LightningWeb.Components.DesignSystemComponents
  use PhoenixStorybook.Story, :component

  def function, do: &DesignSystemComponents.button/1

  def variations do
    [
      %Variation{
        id: :primary,
        description: "Primary button (default variant)",
        attributes: %{variant: :primary},
        slots: ["Primary"]
      },
      %Variation{
        id: :secondary,
        description: "Secondary button with outline style",
        attributes: %{variant: :secondary},
        slots: ["Secondary"]
      },
      %Variation{
        id: :danger,
        description: "Danger button for destructive actions",
        attributes: %{variant: :danger},
        slots: ["Danger"]
      },
      %Variation{
        id: :success,
        description: "Success button for positive actions",
        attributes: %{variant: :success},
        slots: ["Success"]
      },
      %Variation{
        id: :warning,
        description: "Warning button for caution actions",
        attributes: %{variant: :warning},
        slots: ["Warning"]
      },
      %Variation{
        id: :custom,
        description: "Custom button with no preset styles",
        attributes: %{
          variant: :custom,
          class: "bg-purple-600 text-white px-4 py-2"
        },
        slots: ["Custom"]
      },
      %Variation{
        id: :small,
        description: "Small button size",
        attributes: %{size: :sm},
        slots: ["Small"]
      },
      %Variation{
        id: :medium,
        description: "Medium button size (default)",
        attributes: %{size: :md},
        slots: ["Medium"]
      },
      %Variation{
        id: :large,
        description: "Large button size",
        attributes: %{size: :lg},
        slots: ["Large"]
      },
      %Variation{
        id: :disabled_primary,
        description: "Disabled primary button",
        attributes: %{variant: :primary, disabled: true},
        slots: ["Disabled Primary"]
      },
      %Variation{
        id: :disabled_secondary,
        description: "Disabled secondary button",
        attributes: %{variant: :secondary, disabled: true},
        slots: ["Disabled Secondary"]
      },
      %Variation{
        id: :submit,
        description: "Submit button type",
        attributes: %{type: "submit", variant: :primary},
        slots: ["Submit"]
      }
    ]
  end
end
