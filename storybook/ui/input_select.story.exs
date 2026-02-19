defmodule LightningWeb.Storybook.UI.InputSelect do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.input/1

  def variations do
    [
      %Variation{
        id: :basic,
        description: "Basic select dropdown",
        attributes: %{
          type: "select",
          name: "country",
          label: "Country",
          options: [
            {"United States", "us"},
            {"Canada", "ca"},
            {"Mexico", "mx"}
          ]
        }
      },
      %Variation{
        id: :with_prompt,
        description: "Select with placeholder prompt",
        attributes: %{
          type: "select",
          name: "role",
          label: "Role",
          prompt: "Select a role",
          options: [
            {"Admin", "admin"},
            {"Editor", "editor"},
            {"Viewer", "viewer"}
          ]
        }
      },
      %Variation{
        id: :with_value,
        description: "Select with pre-selected value",
        attributes: %{
          type: "select",
          name: "plan",
          label: "Subscription Plan",
          value: "pro",
          options: [
            {"Free", "free"},
            {"Pro", "pro"},
            {"Enterprise", "enterprise"}
          ]
        }
      },
      %Variation{
        id: :required,
        description: "Required select with asterisk",
        attributes: %{
          type: "select",
          name: "category",
          label: "Category",
          required: true,
          prompt: "Choose a category",
          options: [
            {"Technology", "tech"},
            {"Business", "biz"},
            {"Health", "health"}
          ]
        }
      },
      %Variation{
        id: :with_errors,
        description: "Select with validation errors",
        attributes: %{
          type: "select",
          name: "invalid_select",
          label: "Selection",
          errors: ["is required"],
          options: [
            {"Option 1", "opt1"},
            {"Option 2", "opt2"}
          ]
        }
      },
      %Variation{
        id: :disabled,
        description: "Disabled select",
        attributes: %{
          type: "select",
          name: "locked_select",
          label: "Locked Selection",
          disabled: true,
          value: "opt1",
          options: [
            {"Option 1", "opt1"},
            {"Option 2", "opt2"}
          ]
        }
      },
      %Variation{
        id: :custom_select,
        description: "Custom select with search (type: custom-select)",
        attributes: %{
          type: "custom-select",
          name: "custom_country",
          id: "custom_country",
          label: "Country (Custom)",
          prompt: "Select a country",
          value: "us",
          options: [
            {"United States", "us"},
            {"Canada", "ca"},
            {"Mexico", "mx"},
            {"United Kingdom", "uk"},
            {"Germany", "de"}
          ]
        }
      },
      %Variation{
        id: :with_tooltip,
        description: "Select with label tooltip",
        attributes: %{
          type: "select",
          name: "region",
          id: "region-select",
          label: "Region",
          tooltip: "Choose the region closest to your users",
          options: [
            {"US East", "us-east"},
            {"US West", "us-west"},
            {"Europe", "eu"}
          ]
        }
      }
    ]
  end
end
