# config/initializers/assets.rb

module ExternalAssetPipeline
  mattr_accessor :manifest

  class Configuration
    attr_accessor :assets_prefix,
                  :cache_manifest,
                  :manifest_filename,
                  :public_path

    alias cache_manifest? cache_manifest

    def initialize
      @assets_prefix = '/packs'
      @cache_manifest = true
      @manifest_filename = 'manifest.json'
    end

    def configure
      yield self
      self
    end

    def manifest_path
      @public_path.join(public_subdirectory, @manifest_filename)
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
end

configuration = ExternalAssetPipeline::Configuration.new.configure do |config|
  config.cache_manifest = Rails.application.config.cache_revisioned_asset_manifest
  config.manifest_filename = '.revisioned-asset-manifest.json'
  config.public_path = Rails.root.join('public')
end
ExternalAssetPipeline.manifest = ExternalAssetPipeline::Manifest.new(configuration)

ActionView::Base.include ExternalAssetPipeline::Helper
