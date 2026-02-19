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
          checked: false
        }
      },
      %Variation{
        id: :checked,
        description: "Checked checkbox",
        attributes: %{
          type: "checkbox",
          name: "subscribe",
          label: "Subscribe to newsletter",
          checked: true
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
          checked: false
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
          checked: false
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
          checked: true
        }
      },
      %Variation{
        id: :with_errors,
        description: "Checkbox with validation errors",
        attributes: %{
          type: "checkbox",
          name: "must_agree",
          label: "You must agree to continue",
          checked: false,
          errors: ["must be accepted"]
        }
      }
    ]
  end
end
