# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/dev_server'
require 'json'
require 'logger'
require 'net/http'
require 'rack'

module ExternalAssetPipeline
  class DevServerTest < Minitest::Test
    def test_get
      config = Configuration::DevServerSettings.new
      config.host = ENV.fetch('DEV_SERVER_HOST', 'localhost')
      config.port = 9555

      dev_server = DevServer.new(config)

      server_thread = create_server_thread(config.port)
      wait_for_server(config.host, config.port)

      assert_equal '{"foo":"/bar"}', dev_server.get('/bar').body
      assert_equal '{"foo":"/baz"}', dev_server.get('/baz').body
    ensure
      server_thread.kill
    end

    def test_origin
      config = Configuration::DevServerSettings.new
      config.host = ENV.fetch('DEV_SERVER_HOST', 'localhost')
      config.port = 9666

      dev_server = DevServer.new(config)

      assert_equal "http://#{config.host}:9666", dev_server.origin

      config.public_origin = 'http://myapp.test:4444'

      assert_equal 'http://myapp.test:4444', dev_server.origin

      config.public_origin = nil

      assert_equal "http://#{config.host}:9666", dev_server.origin
    end

    def test_running
      config = Configuration::DevServerSettings.new
      config.host = ENV.fetch('DEV_SERVER_HOST', 'localhost')
      config.port = 9777

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
          lambda do |env|
            response = JSON.generate(foo: env['PATH_INFO'])
            [200, { 'Content-Type' => 'application/json' }, [response]]
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
