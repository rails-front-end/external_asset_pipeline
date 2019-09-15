# frozen_string_literal: true

require 'external_asset_pipeline'

module ExternalAssetPipeline
  module Helper
    # This helper method can be overridden to return a different Manifest
    # instance, e.g. to have distinct instances in different rails engines.
    def external_asset_pipeline_manifest
      ExternalAssetPipeline.manifest
    end

    # Overrides the built-in
    # `ActionView::Helpers::AssetUrlHelper#compute_asset_path` to use the
    # external asset pipeline, in the same manner that sprockets-rails does:
    # https://github.com/rails/sprockets-rails/blob/v3.2.1/lib/sprockets/rails/helper.rb#L74-L96
    def compute_asset_path(source, options = {})
      manifest = external_asset_pipeline_manifest
      asset = manifest.find(source)

      options[:host] = asset[:host] if asset && asset[:host]

      return asset[:path] if asset
      return super if manifest.fall_back_to_sprockets?

      raise AssetNotFound,
            "The asset #{source.inspect} is not present in the asset manifest"
    end
  end
end
