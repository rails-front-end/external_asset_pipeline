# frozen_string_literal: true

require 'json'

require 'external_asset_pipeline/manifest'

module ExternalAssetPipeline
  class ServerManifest < Manifest
    def initialize(config:, server:)
      @server = server
      super(config)
    end

    def find(name)
      value = super
      value&.merge(host: @server.origin)
    end

    private

    def data
      load
    end

    def load
      if @server.running?
        manifest_path = "#{@config.assets_prefix}/#{@config.manifest_filename}"
        response = @server.get(manifest_path)
        JSON.parse response.body
      else
        warning =
          "#{@server.class} is not running; returning empty ServerManifest"
        @config.logger.warn warning
        {}
      end
    end
  end
end
