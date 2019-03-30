# frozen_string_literal: true

module ExternalAssetPipeline
  class Configuration
    attr_accessor :assets_prefix,
                  :cache_manifest,
                  :fall_back_to_sprockets,
                  :manifest_filename,
                  :public_path

    alias cache_manifest? cache_manifest
    alias fall_back_to_sprockets? fall_back_to_sprockets

    def initialize
      @assets_prefix = '/packs'
      @cache_manifest = true
      @fall_back_to_sprockets = false
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
end
