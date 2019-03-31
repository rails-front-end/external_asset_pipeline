# frozen_string_literal: true

require 'net/http'

module ExternalAssetPipeline
  class DevServer
    def initialize(config)
      @config = config
    end

    def origin
      "http://#{@config.host}:#{@config.port}"
    end

    def running?
      Socket.tcp(
        @config.host,
        @config.port,
        connect_timeout: @config.connect_timeout
      ).close
      true
    rescue StandardError
      false
    end
  end
end
