defmodule LightningWeb.Storybook.UI.ButtonLink do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.button_link/1

  def variations do
    [
      %Variation{
        id: :primary,
        description: "Primary button link",
        attributes: %{theme: "primary", size: "md", href: "#"},
        slots: ["Primary Link"]
      },
      %Variation{
        id: :secondary,
        description: "Secondary button link",
        attributes: %{theme: "secondary", href: "#"},
        slots: ["Secondary Link"]
      },
      %Variation{
        id: :danger,
        description: "Danger button link",
        attributes: %{theme: "danger", href: "#"},
        slots: ["Danger Link"]
      },
      %Variation{
        id: :success,
        description: "Success button link",
        attributes: %{theme: "success", href: "#"},
        slots: ["Success Link"]
      },
      %Variation{
        id: :warning,
        description: "Warning button link",
        attributes: %{theme: "warning", href: "#"},
        slots: ["Warning Link"]
      },
      %Variation{
        id: :small,
        description: "Small button link",
        attributes: %{theme: "primary", size: "sm", href: "#"},
        slots: ["Small Link"]
      },
      %Variation{
        id: :medium,
        description: "Medium button link (default)",
        attributes: %{theme: "primary", size: "md", href: "#"},
        slots: ["Medium Link"]
      },
      %Variation{
        id: :large,
        description: "Large button link",
        attributes: %{theme: "primary", size: "lg", href: "#"},
        slots: ["Large Link"]
      },
      %Variation{
        id: :disabled,
        description: "Disabled button link (renders as span)",
        attributes: %{theme: "primary", disabled: true},
        slots: ["Disabled Link"]
      },
      %Variation{
        id: :external,
        description: "External link with target",
        attributes: %{
          theme: "primary",
          href: "https://example.com",
          target: "_blank"
        },
        slots: ["External Link"]
      }
    ]
  end
end
