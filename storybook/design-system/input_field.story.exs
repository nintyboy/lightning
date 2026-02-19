defmodule LightningWeb.Storybook.DesignSystem.InputField do
  alias LightningWeb.Components.DesignSystemComponents
  use PhoenixStorybook.Story, :component

  def function, do: &DesignSystemComponents.input_field/1

  def variations do
    [
      %Variation{
        id: :basic,
        description: "Basic input field with label",
        attributes: %{
          name: "username",
          label: "Username",
          placeholder: "Enter your username"
        }
      },
      %Variation{
        id: :required,
        description: "Required input field with asterisk",
        attributes: %{
          name: "email",
          type: "email",
          label: "Email Address",
          required: true,
          placeholder: "you@example.com"
        }
      },
      %Variation{
        id: :with_sublabel,
        description: "Input field with sublabel",
        attributes: %{
          name: "api_key",
          label: "API Key",
          sublabel: "You can find this in your account settings",
          placeholder: "sk_..."
        }
      },
      %Variation{
        id: :with_help_text,
        description: "Input field with help text",
        attributes: %{
          name: "password",
          type: "password",
          label: "Password",
          help_text: "Must be at least 8 characters long",
          placeholder: "Enter password"
        }
      },
      %Variation{
        id: :with_errors,
        description: "Input field with validation errors",
        attributes: %{
          name: "email",
          type: "email",
          label: "Email Address",
          value: "invalid-email",
          errors: ["must be a valid email address", "is already taken"]
        }
      },
      %Variation{
        id: :required_with_errors,
        description: "Required field with errors",
        attributes: %{
          name: "username",
          label: "Username",
          required: true,
          value: "a",
          errors: ["must be at least 3 characters"]
        }
      },
      %Variation{
        id: :full_example,
        description: "Complete example with all features",
        attributes: %{
          name: "full_name",
          label: "Full Name",
          sublabel: "As it appears on your official documents",
          required: true,
          help_text: "First and last name",
          placeholder: "John Doe"
        }
      },
      %Variation{
        id: :disabled,
        description: "Disabled input field",
        attributes: %{
          name: "locked_field",
          label: "Locked Field",
          value: "Cannot edit this",
          disabled: true
        }
      }
    ]
  end
end
