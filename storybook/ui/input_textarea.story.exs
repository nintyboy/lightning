defmodule LightningWeb.Storybook.UI.InputTextarea do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.input/1

  def variations do
    [
      %Variation{
        id: :basic,
        description: "Basic textarea",
        attributes: %{
          type: "textarea",
          name: "description",
          label: "Description",
          placeholder: "Enter a description..."
        }
      },
      %Variation{
        id: :with_value,
        description: "Textarea with initial value",
        attributes: %{
          type: "textarea",
          name: "bio",
          label: "Bio",
          value:
            "This is a sample biography text that spans multiple lines and demonstrates how the textarea displays content."
        }
      },
      %Variation{
        id: :with_rows,
        description: "Textarea with custom rows",
        attributes: %{
          type: "textarea",
          name: "notes",
          label: "Notes",
          placeholder: "Enter notes...",
          rows: 8
        }
      },
      %Variation{
        id: :required,
        description: "Required textarea with asterisk",
        attributes: %{
          type: "textarea",
          name: "message",
          label: "Message",
          required: true,
          placeholder: "This field is required"
        }
      },
      %Variation{
        id: :with_errors,
        description: "Textarea with validation errors",
        attributes: %{
          type: "textarea",
          name: "invalid_text",
          label: "Comments",
          value: "Too short",
          errors: ["must be at least 20 characters"]
        }
      },
      %Variation{
        id: :disabled,
        description: "Disabled textarea",
        attributes: %{
          type: "textarea",
          name: "locked_text",
          label: "Locked Content",
          value: "This content cannot be edited",
          disabled: true
        }
      },
      %Variation{
        id: :codearea,
        description: "Code textarea with monospace font and dark background",
        attributes: %{
          type: "codearea",
          name: "code",
          label: "JavaScript Code",
          placeholder: "Enter code here...",
          value: "function hello() {\n  console.log('Hello, world!');\n}"
        }
      },
      %Variation{
        id: :codearea_large,
        description: "Large code textarea",
        attributes: %{
          type: "codearea",
          name: "script",
          label: "Script",
          rows: 12,
          value:
            "// Import modules\nimport { getData } from './api';\n\n// Main function\nasync function main() {\n  const data = await getData();\n  console.log(data);\n}\n\n// Execute\nmain();"
        }
      }
    ]
  end
end
