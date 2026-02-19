defmodule LightningWeb.Storybook.DesignSystem.Input do
  alias LightningWeb.Components.DesignSystemComponents
  use PhoenixStorybook.Story, :component

  def function, do: &DesignSystemComponents.input/1

  def variations do
    [
      %Variation{
        id: :text,
        description: "Text input (default)",
        attributes: %{
          type: "text",
          name: "username",
          placeholder: "Enter username"
        }
      },
      %Variation{
        id: :email,
        description: "Email input",
        attributes: %{
          type: "email",
          name: "email",
          placeholder: "name@example.com"
        }
      },
      %Variation{
        id: :password,
        description: "Password input",
        attributes: %{
          type: "password",
          name: "password",
          placeholder: "Enter password"
        }
      },
      %Variation{
        id: :number,
        description: "Number input",
        attributes: %{
          type: "number",
          name: "age",
          placeholder: "Enter age"
        }
      },
      %Variation{
        id: :with_error,
        description: "Input with error state",
        attributes: %{
          type: "text",
          name: "field",
          value: "Invalid value",
          errors: ["This field is invalid"]
        }
      },
      %Variation{
        id: :disabled,
        description: "Disabled input",
        attributes: %{
          type: "text",
          name: "disabled_field",
          value: "Cannot edit",
          disabled: true
        }
      },
      %Variation{
        id: :url,
        description: "URL input",
        attributes: %{
          type: "url",
          name: "website",
          placeholder: "https://example.com"
        }
      },
      %Variation{
        id: :search,
        description: "Search input",
        attributes: %{
          type: "search",
          name: "search",
          placeholder: "Search..."
        }
      }
    ]
  end
end
