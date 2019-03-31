# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/dev_server'
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

      server_thread = Thread.new do
        Rack::Handler::WEBrick.run(
          lambda do |_|
            [200, { 'Content-Type' => 'application/json' }, ['{"foo":"bar"}']]
          end,
          Port: 9555
        )
      end

      loop do
        begin
          response = Net::HTTP.start('localhost', 9555) { |http| http.get('/') }
        rescue Errno::ECONNREFUSED
          next
        end
        break if response.is_a?(Net::HTTPSuccess)
      end

      assert_predicate dev_server, :running?
    ensure
      server_thread.kill
    end
  end
end
