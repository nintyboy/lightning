defmodule LightningWeb.Storybook.React.Input do
  alias LightningWeb.Components.ReactComponents
  use PhoenixStorybook.Story, :component

  def function, do: &ReactComponents.input_field/1

  def variations do
    [
      %Variation{
        id: :text,
        description: "Text input",
        attributes: %{
          name: "text_field",
          type: "text",
          label: "Text Input",
          placeholder: "Enter some text",
          value: ""
        }
      },
      %Variation{
        id: :email,
        description: "Email input",
        attributes: %{
          name: "email_field",
          type: "email",
          label: "Email Address",
          placeholder: "you@example.com",
          value: ""
        }
      },
      %Variation{
        id: :password,
        description: "Password input",
        attributes: %{
          name: "password_field",
          type: "password",
          label: "Password",
          value: ""
        }
      },
      %Variation{
        id: :with_help,
        description: "Input with help text",
        attributes: %{
          name: "help_field",
          type: "text",
          label: "Username",
          help_text: "Choose a unique username for your account",
          value: ""
        }
      },
      %Variation{
        id: :required,
        description: "Required input",
        attributes: %{
          name: "required_field",
          type: "text",
          label: "Full Name",
          required: true,
          value: ""
        }
      }
    ]
  end
end
