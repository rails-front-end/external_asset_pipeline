# frozen_string_literal: true

require 'logger'

module ExternalAssetPipeline
  class Configuration
    attr_accessor :assets_prefix,
                  :cache_manifest,
                  :dev_server,
                  :fall_back_to_sprockets,
                  :logger,
                  :manifest_filename,
                  :prepend_assets_prefix_to_manifest_values,
                  :public_path

    alias cache_manifest? cache_manifest
    alias fall_back_to_sprockets? fall_back_to_sprockets

    class DevServerSettings
      attr_accessor :connect_timeout,
                    :enabled,
                    :host,
                    :port,
                    :public_origin

      def initialize
        @connect_timeout = 0.01
        @host = 'localhost'
        @port = 3035
      end
    end

    def initialize
      @assets_prefix = '/packs'
      @cache_manifest = true
      @dev_server = DevServerSettings.new
      @fall_back_to_sprockets = false
      @logger = Logger.new($stdout)
      @manifest_filename = 'manifest.json'
      @prepend_assets_prefix_to_manifest_values = true
    end

    def manifest_value_prefix
      @prepend_assets_prefix_to_manifest_values ? "#{@assets_prefix}/" : ''
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
