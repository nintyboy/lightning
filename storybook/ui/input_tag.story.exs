defmodule LightningWeb.Storybook.UI.InputTag do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.input/1

  def variations do
    [
      %Variation{
        id: :empty,
        description: "Empty tag input",
        attributes: %{
          type: "tag",
          id: "tags-1",
          name: "keywords",
          label: "Keywords",
          placeholder: "Type and press Enter to add tags"
        }
      },
      %Variation{
        id: :with_tags,
        description: "Tag input with existing tags",
        attributes: %{
          type: "tag",
          id: "tags-2",
          name: "skills",
          label: "Skills",
          value: "JavaScript, Elixir, React, Phoenix",
          placeholder: "Add more skills..."
        }
      },
      %Variation{
        id: :with_sublabel,
        description: "Tag input with sublabel",
        attributes: %{
          type: "tag",
          id: "tags-3",
          name: "categories",
          label: "Categories",
          sublabel: "Separate tags with commas or press Enter",
          value: "web, mobile, desktop",
          placeholder: "Add categories..."
        }
      },
      %Variation{
        id: :required,
        description: "Required tag input with asterisk",
        attributes: %{
          type: "tag",
          id: "tags-4",
          name: "required_tags",
          label: "Tags",
          required: true,
          placeholder: "At least one tag required"
        }
      },
      %Variation{
        id: :with_errors,
        description: "Tag input with validation errors",
        attributes: %{
          type: "tag",
          id: "tags-5",
          name: "invalid_tags",
          label: "Project Tags",
          value: "",
          errors: ["at least one tag is required"],
          placeholder: "Add tags..."
        }
      },
      %Variation{
        id: :many_tags,
        description: "Tag input with many tags",
        attributes: %{
          type: "tag",
          id: "tags-6",
          name: "tech_stack",
          label: "Technology Stack",
          value:
            "HTML, CSS, JavaScript, TypeScript, React, Vue, Angular, Node.js, Express, PostgreSQL, MongoDB, Redis, Docker, Kubernetes",
          placeholder: "Add more technologies..."
        }
      },
      %Variation{
        id: :standalone,
        description: "Standalone tag input (not in a form)",
        attributes: %{
          type: "tag",
          id: "tags-7",
          name: "standalone_tags",
          label: "Tags (Standalone Mode)",
          value: "tag1, tag2, tag3",
          standalone: true,
          placeholder: "Add tags..."
        }
      }
    ]
  end
end
