# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/dev_server'
require 'logger'
require 'net/http'
require 'rack'

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

      server_thread = create_server_thread(config.port)
      wait_for_server(config.host, config.port)

      assert_predicate dev_server, :running?
    ensure
      server_thread.kill
    end

    private

    def create_server_thread(port)
      Thread.new do
        Rack::Handler::WEBrick.run(
          lambda do |_|
            [200, { 'Content-Type' => 'application/json' }, ['{"foo":"bar"}']]
          end,
          AccessLog: [],
          Logger: Logger.new(nil),
          Port: port
        )
      end
    end

    def wait_for_server(host, port)
      loop do
        begin
          response = Net::HTTP.start(host, port) { |http| http.get('/') }
        rescue Errno::ECONNREFUSED
          next
        end
        break if response.is_a?(Net::HTTPSuccess)
      end
    end
  end
end
