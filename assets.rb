# config/initializers/assets.rb

module ExternalAssetPipeline
  mattr_accessor :manifest

  class Manifest
    def find(name)
      data[name.to_s].presence
    end

    private

    def data
      if Rails.application.config.cache_revisioned_asset_manifest
        @data ||= load
      else
        load
      end
    end

    def load
      manifest_file_path = Rails.root.join('public', 'packs', '.revisioned-asset-manifest.json')
      JSON.parse(manifest_file_path.read)
    end
  end

  # Overrides the built-in `ActionView::Helpers::AssetUrlHelper#compute_asset_path` to use the
  # external asset pipeline, in the same manner that sprockets-rails does:
  # https://github.com/rails/sprockets-rails/blob/v3.2.1/lib/sprockets/rails/helper.rb#L74-L96
  def compute_asset_path(source, options = {})
    value_in_asset_manifest = ExternalAssetPipeline.manifest.find(source)

    if value_in_asset_manifest
      "/packs/#{value_in_asset_manifest}"
    else
      super(source, options)
    end
  end
end

ExternalAssetPipeline.manifest = ExternalAssetPipeline::Manifest.new

ActionView::Base.include ExternalAssetPipeline
