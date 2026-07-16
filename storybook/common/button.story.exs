defmodule LightningWeb.Storybook.Common.Button do
  use PhoenixStorybook.Story, :component

  # The canonical design-system button (recipe-backed).
  # See assets/packages/ui/recipes/button.json.
  # (Previously pointed at Common.button/1, which no longer exists.)
  def function, do: &LightningWeb.Components.UI.Button.button/1

  def variations do
    [
      %VariationGroup{
        id: :themes,
        description: "Themes",
        variations:
          for theme <- ~w(primary secondary danger success warning ghost) do
            %Variation{
              id: String.to_atom(theme),
              attributes: %{theme: theme},
              slots: [String.capitalize(theme)]
            }
          end
      },
      %VariationGroup{
        id: :sizes,
        description: "Sizes",
        variations:
          for size <- ~w(sm md lg) do
            %Variation{
              id: String.to_atom("size_#{size}"),
              attributes: %{theme: "primary", size: size},
              slots: [String.upcase(size)]
            }
          end
      },
      %VariationGroup{
        id: :states,
        description: "States",
        variations: [
          %Variation{
            id: :disabled,
            attributes: %{theme: "primary", disabled: true},
            slots: ["Disabled"]
          },
          %Variation{
            id: :disabled_with_tooltip,
            attributes: %{
              id: "disabled-tooltip-demo",
              theme: "primary",
              disabled: true,
              tooltip: "Why this is disabled"
            },
            slots: ["Disabled with tooltip"]
          }
        ]
      }
    ]
  end
end
