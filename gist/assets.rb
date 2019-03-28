# config/initializers/assets.rb

module ExternalAssetPipeline
  class AssetNotFound < StandardError; end

  mattr_accessor :manifest

  class Configuration
    attr_accessor :assets_prefix,
                  :cache_manifest,
                  :manifest_filename

    alias cache_manifest? cache_manifest

    def initialize
      @assets_prefix = '/packs'
      @cache_manifest = true
      @manifest_filename = 'manifest.json'
    end

    def manifest_path
      Rails.root.join('public', public_subdirectory, @manifest_filename)
    end

    private

    def public_subdirectory
      @assets_prefix[1..-1]
    end
  end

  class Manifest
    def initialize(config)
      @config = config
    end

    def find(name)
      value = data[name.to_s]
      "#{@config.assets_prefix}/#{value}" if value
    end

    private

    def data
      if @config.cache_manifest?
        @data ||= load
      else
        load
      end
    end

    def load
      JSON.parse(@config.manifest_path.read)
    end
  end

  # Overrides the built-in `ActionView::Helpers::AssetUrlHelper#compute_asset_path` to use the
  # external asset pipeline, in the same manner that sprockets-rails does:
  # https://github.com/rails/sprockets-rails/blob/v3.2.1/lib/sprockets/rails/helper.rb#L74-L96
  def compute_asset_path(source, _options = {})
    value_in_asset_manifest = ExternalAssetPipeline.manifest.find(source)

    return value_in_asset_manifest if value_in_asset_manifest

    raise AssetNotFound,
          "The asset #{source.inspect} is not present in the asset manifest"
  end
end

configuration = ExternalAssetPipeline::Configuration.new
configuration.cache_manifest = Rails.application.config.cache_revisioned_asset_manifest
configuration.manifest_filename = '.revisioned-asset-manifest.json'
ExternalAssetPipeline.manifest = ExternalAssetPipeline::Manifest.new(configuration)

ActionView::Base.include ExternalAssetPipeline
