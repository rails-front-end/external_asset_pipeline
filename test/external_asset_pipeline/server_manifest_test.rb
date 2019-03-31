# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/dev_server'
require 'external_asset_pipeline/server_manifest'
require 'json'

module ExternalAssetPipeline
  class ServerManifestTest < Minitest::Test
    TEST_APP_PUBLIC_PATH = File.expand_path('../test_app/public', __dir__)

    def setup
      @config = Configuration.new
      @config.dev_server.host = 'localhost'
      @config.dev_server.port = 9555
      @config.logger = LoggerDouble.new
    end

    def test_find
      server_stub = ServerDouble.new(@config.dev_server)
      manifest = ServerManifest.new(config: @config, server: server_stub)

      assert_nil manifest.find('application.js')

      expected_log_warning =
        "#{server_stub.class} is not running; returning empty ServerManifest"
      assert_equal [expected_log_warning], @config.logger.messages

      assert_nil manifest.find('application.css')
      assert_nil manifest.find('missing-asset.css')
      assert_equal [expected_log_warning] * 3, @config.logger.messages
      assert_nil server_stub.path

      server_stub.running = true

      expected_host = 'http://localhost:9555'
      assert_equal(
        { host: expected_host, path: '/packs/application-from-server.js' },
        manifest.find('application.js')
      )
      assert_equal(
        { host: expected_host, path: '/packs/application-from-server.css' },
        manifest.find('application.css')
      )
      assert_nil manifest.find('missing-asset.css')
      assert_equal [expected_log_warning] * 3, @config.logger.messages
      assert_equal '/packs/manifest.json', server_stub.path
    end

    class LoggerDouble
      attr_reader :messages

      def warn(message)
        @messages ||= []
        @messages << message
      end
    end

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
end
