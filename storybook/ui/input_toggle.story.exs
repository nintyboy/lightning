defmodule LightningWeb.Storybook.UI.InputToggle do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  def function, do: &NewInputs.input/1

  def variations do
    [
      %Variation{
        id: :toggle_off,
        description: "Toggle switch (off/unchecked)",
        attributes: %{
          type: "toggle",
          id: "toggle-1",
          name: "notifications",
          label: "Enable Notifications",
          value: false
        }
      },
      %Variation{
        id: :toggle_on,
        description: "Toggle switch (on/checked)",
        attributes: %{
          type: "toggle",
          id: "toggle-2",
          name: "dark_mode",
          label: "Dark Mode",
          value: true
        }
      },
      %Variation{
        id: :toggle_disabled_off,
        description: "Disabled toggle (off)",
        attributes: %{
          type: "toggle",
          id: "toggle-3",
          name: "disabled_feature",
          label: "Disabled Feature",
          value: false,
          disabled: true
        }
      },
      %Variation{
        id: :toggle_disabled_on,
        description: "Disabled toggle (on)",
        attributes: %{
          type: "toggle",
          id: "toggle-4",
          name: "locked_setting",
          label: "Locked Setting",
          value: true,
          disabled: true
        }
      },
      %Variation{
        id: :toggle_with_sublabel,
        description: "Toggle with sublabel",
        attributes: %{
          type: "toggle",
          id: "toggle-5",
          name: "auto_save",
          label: "Auto Save",
          sublabel: "Automatically save your work every 30 seconds",
          value: true
        }
      },
      %Variation{
        id: :integer_toggle_off,
        description: "Integer toggle (type: integer-toggle, off state)",
        attributes: %{
          type: "integer-toggle",
          id: "int-toggle-1",
          name: "feature_flag",
          value: "0",
          max: "1"
        }
      },
      %Variation{
        id: :integer_toggle_on,
        description: "Integer toggle (type: integer-toggle, on state)",
        attributes: %{
          type: "integer-toggle",
          id: "int-toggle-2",
          name: "enabled_flag",
          value: "1",
          max: "1"
        }
      },
      %Variation{
        id: :integer_toggle_disabled,
        description: "Disabled integer toggle",
        attributes: %{
          type: "integer-toggle",
          id: "int-toggle-3",
          name: "locked_flag",
          value: "1",
          max: "1",
          disabled: true
        }
      }
    ]
  end
end
