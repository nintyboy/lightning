defmodule LightningWeb.Storybook do
  @moduledoc false

  use Lightning.BuildMacros

  do_in(:dev) do
    use PhoenixStorybook,
      color_mode: true,
      otp_app: :lightning_web,
      content_path: Path.expand("../../storybook", __DIR__),
      # assets path are remote path, not local file-system paths
      css_path:
        "https://app.openfn.org/assets/app-15e399ecbc58855c09a47e3e57a44555.css",
      js_path: "/assets/js/storybook.js",
      sandbox_class: "lightning-web",
      # asset hashing function for cache busting
      asset_hash: &LightningWeb.Storybook.asset_hash/1
  end

  @spec asset_hash(any()) :: <<>>
  @doc """
  Returns the asset hash for cache busting.
  In development, we return an empty string to disable caching.
  """
  def asset_hash(_path), do: ""
end
