# config/initializers/assets.rb

module WebpackAssetPipeline
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

  def path_to_asset(source, options = {})
    value_in_webpack_manifest =
      WebpackAssetPipeline.manifest.find(pack_name_with_extension(source, options))

    super(
      value_in_webpack_manifest.present? ? "/packs/#{value_in_webpack_manifest}" : source,
      options.merge(skip_pipeline: value_in_webpack_manifest.present?)
    )
  end
  alias asset_path path_to_asset

  private

  def pack_name_with_extension(name, options)
    "#{name}#{compute_asset_extname(name, options)}"
  end
end

WebpackAssetPipeline.manifest = WebpackAssetPipeline::Manifest.new

ActionView::Base.include WebpackAssetPipeline
