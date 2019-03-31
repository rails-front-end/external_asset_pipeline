# frozen_string_literal: true

require 'external_asset_pipeline/dev_server'

module ExternalAssetPipeline
  class ServerDouble < DevServer
    attr_accessor :running
    attr_reader :path

    def get(path)
      @path = path

      Struct.new(:body).new(
        JSON.generate(
          'application.js' => 'application-from-server.js',
          'application.css' => 'application-from-server.css'
        )
      )
    end

    def running?
      running
    end
  end
end
