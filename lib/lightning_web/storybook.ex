defmodule LightningWeb.Storybook do
  @moduledoc false

  use Lightning.BuildMacros

  do_in(:dev) do
    use PhoenixStorybook,
      otp_app: :lightning,
      content_path: Path.expand("../../storybook", __DIR__),
      # assets path are remote path, not local file-system paths
      css_path: "/assets/storybook.css",
      js_path: "/assets/js/storybook.js",
      js_script_type: "module",
      sandbox_class: "lightning-web"
  end
end
