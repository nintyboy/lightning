defmodule LightningWeb.Storybook.UI.Button do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.button/1

  def variations do
    [
      %Variation{
        id: :primary,
        description: "Primary button (default theme)",
        attributes: %{
          theme: "primary",
          enabled: true,
          tooltip: "I am a primary button"
        },
        slots: ["Primary"]
      },
      %Variation{
        id: :secondary,
        description: "Secondary button with outline style",
        attributes: %{theme: "secondary"},
        slots: ["Secondary"]
      },
      %Variation{
        id: :danger,
        description: "Danger button for destructive actions",
        attributes: %{theme: "danger"},
        slots: ["Danger"]
      },
      %Variation{
        id: :success,
        description: "Success button for positive actions",
        attributes: %{theme: "success"},
        slots: ["Success"]
      },
      %Variation{
        id: :warning,
        description: "Warning button for caution actions",
        attributes: %{theme: "warning"},
        slots: ["Warning"]
      },
      %Variation{
        id: :custom,
        description: "Custom button with no preset styles",
        attributes: %{
          theme: "custom",
          class: "bg-purple-600 text-white hover:bg-purple-500 px-4 py-2"
        },
        slots: ["Custom"]
      },
      %Variation{
        id: :small,
        description: "Small button size",
        attributes: %{theme: "primary", size: "sm"},
        slots: ["Small"]
      },
      %Variation{
        id: :medium,
        description: "Medium button size (default)",
        attributes: %{theme: "primary", size: "md"},
        slots: ["Medium"]
      },
      %Variation{
        id: :large,
        description: "Large button size",
        attributes: %{theme: "primary", size: "lg"},
        slots: ["Large"]
      },
      %Variation{
        id: :disabled_primary,
        description: "Disabled primary button",
        attributes: %{theme: "primary", disabled: true},
        slots: ["Disabled Primary"]
      },
      %Variation{
        id: :disabled_secondary,
        description: "Disabled secondary button",
        attributes: %{theme: "secondary", disabled: true},
        slots: ["Disabled Secondary"]
      },
      %Variation{
        id: :disabled_with_tooltip,
        description: "Disabled button with tooltip",
        attributes: %{
          theme: "primary",
          disabled: true,
          tooltip: "You cannot click this button right now",
          id: "tooltip-btn"
        },
        slots: ["Hover for tooltip"]
      },
      %Variation{
        id: :submit,
        description: "Submit button type",
        attributes: %{theme: "primary", type: "submit"},
        slots: ["Submit"]
      }
    ]
  end
end
