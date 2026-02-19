defmodule LightningWeb.Storybook do
  @moduledoc false

  use Lightning.BuildMacros

  do_in(:dev) do
    use PhoenixStorybook,
      color_mode: true,
      otp_app: :lightning_web,
      content_path: Path.expand("../../storybook", __DIR__),
      # assets path are remote path, not local file-system paths
      css_path: "/assets/storybook.css",
      js_path: "/assets/storybook.js",
      sandbox_class: "lightning-web",
      # asset hashing function for cache busting
      asset_hash: &LightningWeb.Storybook.asset_hash/1
  end

  @doc """
  Returns the asset hash for cache busting.
  In development, we return an empty string to disable caching.
  """
  def asset_hash(_path), do: ""
end
