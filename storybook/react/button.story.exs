defmodule LightningWeb.Storybook.React.Button do
  alias LightningWeb.Components.ReactComponents
  use PhoenixStorybook.Story, :component

  def function, do: &ReactComponents.button/1

  def variations do
    [
      %Variation{
        id: :primary,
        description: "Primary button",
        attributes: %{variant: "primary"},
        slots: ["Primary"]
      },
      %Variation{
        id: :secondary,
        description: "Secondary button",
        attributes: %{variant: "secondary"},
        slots: ["Secondary"]
      },
      %Variation{
        id: :danger,
        description: "Danger button",
        attributes: %{variant: "danger"},
        slots: ["Danger"]
      },
      %Variation{
        id: :success,
        description: "Success button",
        attributes: %{variant: "success"},
        slots: ["Success"]
      },
      %Variation{
        id: :warning,
        description: "Warning button",
        attributes: %{variant: "warning"},
        slots: ["Warning"]
      },
      %Variation{
        id: :small,
        description: "Small button",
        attributes: %{size: "sm"},
        slots: ["Small"]
      },
      %Variation{
        id: :medium,
        description: "Medium button",
        attributes: %{size: "md"},
        slots: ["Medium"]
      },
      %Variation{
        id: :large,
        description: "Large button",
        attributes: %{size: "lg"},
        slots: ["Large"]
      },
      %Variation{
        id: :disabled,
        description: "Disabled button",
        attributes: %{disabled: true, tooltip: "Cannot click this button"},
        slots: ["Disabled"]
      }
    ]
  end
end
