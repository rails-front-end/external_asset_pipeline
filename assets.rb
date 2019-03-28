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

  def path_to_asset(source, options = {})
    return super(source, options) if options[:skip_pipeline]

    value_in_asset_manifest =
      ExternalAssetPipeline.manifest.find(pack_name_with_extension(source, options))

    if value_in_asset_manifest
      super("/packs/#{value_in_asset_manifest}", options.merge(skip_pipeline: true))
    else
      super(source, options)
    end
  end
  alias asset_path path_to_asset

  private

  def pack_name_with_extension(name, options)
    "#{name}#{compute_asset_extname(name, options)}"
  end
end

ExternalAssetPipeline.manifest = ExternalAssetPipeline::Manifest.new

ActionView::Base.include ExternalAssetPipeline
