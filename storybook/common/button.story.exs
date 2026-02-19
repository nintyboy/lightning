defmodule LightningWeb.Storybook.Common.Button do
  alias LightningWeb.Components.NewInputs
  use PhoenixStorybook.Story, :component

  # required
  def function, do: &NewInputs.button/1

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default button",
        attributes: %{},
        slots: ["I'm a button"]
      },
      %Variation{
        id: :with_icon,
        description: "With an Icon",
        attributes: %{},
        slots: [
          """
          <div class="h-full">
            <Heroicons.trash class="h-4 w-4 inline-block" />
            <span class="inline-block align-middle">Remove</span>
          </div>
          """
        ]
      }
    ]
  end
end
