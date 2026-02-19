defmodule LightningWeb.Storybook.DesignSystem.Select do
  alias LightningWeb.Components.DesignSystemComponents
  use PhoenixStorybook.Story, :component

  def function, do: &DesignSystemComponents.select/1

  def variations do
    [
      %Variation{
        id: :basic,
        description: "Basic select dropdown",
        attributes: %{
          name: "country",
          options: [
            %{label: "United States", value: "us"},
            %{label: "Canada", value: "ca"},
            %{label: "Mexico", value: "mx"}
          ]
        }
      },
      %Variation{
        id: :with_prompt,
        description: "Select with placeholder prompt",
        attributes: %{
          name: "role",
          prompt: "Select a role",
          options: [
            %{label: "Admin", value: "admin"},
            %{label: "Editor", value: "editor"},
            %{label: "Viewer", value: "viewer"}
          ]
        }
      },
      %Variation{
        id: :with_label,
        description: "Select with label",
        attributes: %{
          name: "department",
          label: "Department",
          options: [
            %{label: "Engineering", value: "eng"},
            %{label: "Marketing", value: "mkt"},
            %{label: "Sales", value: "sales"}
          ]
        }
      },
      %Variation{
        id: :required,
        description: "Required select with asterisk",
        attributes: %{
          name: "plan",
          label: "Subscription Plan",
          required: true,
          prompt: "Choose a plan",
          options: [
            %{label: "Free", value: "free"},
            %{label: "Pro", value: "pro"},
            %{label: "Enterprise", value: "enterprise"}
          ]
        }
      },
      %Variation{
        id: :with_disabled_option,
        description: "Select with disabled options",
        attributes: %{
          name: "tier",
          label: "Access Tier",
          options: [
            %{label: "Basic", value: "basic"},
            %{label: "Premium (Coming Soon)", value: "premium", disabled: true},
            %{
              label: "Enterprise (Contact Sales)",
              value: "enterprise",
              disabled: true
            }
          ]
        }
      },
      %Variation{
        id: :with_errors,
        description: "Select with validation errors",
        attributes: %{
          name: "category",
          label: "Category",
          errors: ["is required"],
          options: [
            %{label: "Technology", value: "tech"},
            %{label: "Business", value: "biz"},
            %{label: "Health", value: "health"}
          ]
        }
      },
      %Variation{
        id: :disabled,
        description: "Disabled select",
        attributes: %{
          name: "locked_field",
          label: "Locked Selection",
          disabled: true,
          options: [
            %{label: "Option 1", value: "opt1"},
            %{label: "Option 2", value: "opt2"}
          ]
        }
      }
    ]
  end
end
