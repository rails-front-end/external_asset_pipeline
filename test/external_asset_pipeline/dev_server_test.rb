# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/dev_server'

module ExternalAssetPipeline
  class DevServerTest < Minitest::Test
    def test_origin
      config = Configuration::DevServerSettings.new
      config.host = 'localhost'
      config.port = 9555

      dev_server = DevServer.new(config)

      assert_equal 'http://localhost:9555', dev_server.origin
    end

    def test_running
      config = Configuration::DevServerSettings.new
      config.host = 'localhost'
      config.port = 9555

      dev_server = DevServer.new(config)

      refute_predicate dev_server, :running?

      server_thread = Thread.new do
        Socket.tcp_server_loop(config.host, config.port) do |socket, _|
          socket.close
        end
      end

      assert_predicate dev_server, :running?
    ensure
      server_thread.kill
    end
  end
end
