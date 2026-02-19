defmodule LightningWeb.Storybook.React.Select do
  alias LightningWeb.Components.ReactComponents
  use PhoenixStorybook.Story, :component

  def function, do: &ReactComponents.select/1

  def variations do
    [
      %Variation{
        id: :basic,
        description: "Basic select",
        attributes: %{
          name: "status",
          label: "Status",
          options: [{"Active", "active"}, {"Inactive", "inactive"}]
        }
      },
      %Variation{
        id: :with_prompt,
        description: "Select with prompt",
        attributes: %{
          name: "country",
          label: "Country",
          prompt: "Select a country...",
          options: [{"United States", "us"}, {"Canada", "ca"}, {"Mexico", "mx"}]
        }
      },
      %Variation{
        id: :required,
        description: "Required select",
        attributes: %{
          name: "role",
          label: "Role",
          required: true,
          options: [{"Admin", "admin"}, {"User", "user"}, {"Guest", "guest"}]
        }
      }
    ]
  end
end
