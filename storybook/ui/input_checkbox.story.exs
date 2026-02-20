defmodule LightningWeb.Storybook.UI.InputCheckbox do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.input/1

  def variations do
    [
      %Variation{
        id: :unchecked,
        description: "Unchecked checkbox",
        attributes: %{
          type: "checkbox",
          name: "agree",
          label: "I agree to the terms",
          value: "false"
        }
      },
      %Variation{
        id: :checked,
        description: "Checked checkbox",
        attributes: %{
          type: "checkbox",
          name: "subscribe",
          label: "Subscribe to newsletter",
          value: "true"
        }
      },
      %Variation{
        id: :required,
        description: "Required checkbox with asterisk",
        attributes: %{
          type: "checkbox",
          name: "accept_terms",
          label: "Accept Terms and Conditions",
          required: true,
          value: "false"
        }
      },
      %Variation{
        id: :disabled_unchecked,
        description: "Disabled unchecked checkbox",
        attributes: %{
          type: "checkbox",
          name: "disabled_option",
          label: "Disabled option",
          disabled: true,
          value: "false"
        }
      },
      %Variation{
        id: :disabled_checked,
        description: "Disabled checked checkbox",
        attributes: %{
          type: "checkbox",
          name: "preset_option",
          label: "Pre-selected option",
          disabled: true,
          value: "true"
        }
      },
      %Variation{
        id: :with_errors,
        description: "Checkbox with validation errors",
        attributes: %{
          type: "checkbox",
          name: "must_agree",
          label: "You must agree to continue",
          value: "false",
          errors: ["must be accepted"]
        }
      }
    ]
  end
end
