defmodule LightningWeb.Storybook.Common.SplitButton do
  use PhoenixStorybook.Story, :component

  def function, do: &LightningWeb.Components.UI.SplitButton.split_button/1

  def variations do
    [
      %Variation{
        id: :primary,
        description: "Primary (default)",
        attributes: %{id: "save-button", menu_label: "More save options"},
        slots: [
          "Save",
          ~s|<:item id="save-sync" phx-click="noop">Save & Sync</:item>|,
          ~s|<:item id="save-template" disabled>Save as template</:item>|
        ]
      },
      %VariationGroup{
        id: :themes,
        description: "Themes",
        variations:
          for theme <- ~w(secondary danger success warning ghost) do
            %Variation{
              id: String.to_atom(theme),
              attributes: %{
                id: "save-button-#{theme}",
                theme: theme,
                menu_label: "More options"
              },
              slots: [
                String.capitalize(theme),
                ~s|<:item id="alt-#{theme}">Alternative</:item>|
              ]
            }
          end
      },
      %Variation{
        id: :disabled,
        description: "Disabled",
        attributes: %{
          id: "save-button-disabled",
          menu_label: "More save options",
          disabled: true
        },
        slots: [
          "Save",
          ~s|<:item id="save-sync-disabled">Save & Sync</:item>|
        ]
      }
    ]
  end
end
