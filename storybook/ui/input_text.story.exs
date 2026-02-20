defmodule LightningWeb.Storybook.UI.InputText do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.input/1

  def variations do
    [
      %Variation{
        id: :text,
        description: "Text input",
        attributes: %{
          type: "text",
          name: "username",
          label: "Username",
          value: "",
          placeholder: "Enter username"
        }
      },
      %Variation{
        id: :email,
        description: "Email input",
        attributes: %{
          type: "email",
          name: "email",
          label: "Email Address",
          value: "",
          placeholder: "you@example.com"
        }
      },
      %Variation{
        id: :password,
        description: "Password input with reveal toggle",
        attributes: %{
          type: "password",
          name: "password",
          label: "Password",
          value: "",
          placeholder: "Enter password"
        }
      },
      %Variation{
        id: :number,
        description: "Number input",
        attributes: %{
          type: "number",
          name: "age",
          label: "Age",
          value: "",
          placeholder: "Enter age"
        }
      },
      %Variation{
        id: :tel,
        description: "Telephone input",
        attributes: %{
          type: "tel",
          name: "phone",
          label: "Phone Number",
          value: "",
          placeholder: "(555) 555-5555"
        }
      },
      %Variation{
        id: :url,
        description: "URL input",
        attributes: %{
          type: "url",
          name: "website",
          label: "Website",
          value: "",
          placeholder: "https://example.com"
        }
      },
      %Variation{
        id: :date,
        description: "Date input",
        attributes: %{
          type: "date",
          name: "birthday",
          label: "Birthday",
          value: ""
        }
      },
      %Variation{
        id: :time,
        description: "Time input",
        attributes: %{
          type: "time",
          name: "appointment",
          label: "Appointment Time",
          value: ""
        }
      },
      %Variation{
        id: :with_sublabel,
        description: "Input with sublabel",
        attributes: %{
          type: "text",
          name: "api_key",
          label: "API Key",
          sublabel: "You can find this in your account settings",
          value: "",
          placeholder: "sk_..."
        }
      },
      %Variation{
        id: :required,
        description: "Required input with asterisk",
        attributes: %{
          type: "email",
          name: "required_email",
          label: "Email",
          required: true,
          value: "",
          placeholder: "Required field"
        }
      },
      %Variation{
        id: :with_errors,
        description: "Input with validation errors",
        attributes: %{
          type: "email",
          name: "invalid_email",
          label: "Email Address",
          value: "invalid-email",
          errors: ["must be a valid email address"]
        }
      },
      %Variation{
        id: :disabled,
        description: "Disabled input",
        attributes: %{
          type: "text",
          name: "locked",
          label: "Locked Field",
          value: "Cannot edit",
          disabled: true
        }
      },
      %Variation{
        id: :with_tooltip,
        description: "Input with label tooltip",
        attributes: %{
          type: "text",
          name: "field_with_tooltip",
          label: "Field with Info",
          tooltip: "This is additional information about this field",
          value: "",
          id: "tooltip-input"
        }
      }
    ]
  end
end
