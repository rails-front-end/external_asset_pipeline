# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/manifest'
require 'external_asset_pipeline/helper'
require 'external_asset_pipeline/server_double'
require 'external_asset_pipeline/server_manifest'

module ExternalAssetPipeline
  class HelperTest < Minitest::Test
    TEST_APP_PUBLIC_PATH = File.expand_path('../test_app/public', __dir__)

    def teardown
      ExternalAssetPipeline.manifest = nil
    end

    def test_compute_asset_path
      config = Configuration.new
      config.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)
      ExternalAssetPipeline.manifest = Manifest.new(config)

      assert_equal '/packs/application-7b3dc2436f7956c77987.js',
                   view.compute_asset_path('application.js')
      assert_equal '/packs/application-2ea8c3891d.css',
                   view.compute_asset_path('application.css')

      exception = assert_raises(ExternalAssetPipeline::AssetNotFound) do
        view.compute_asset_path('missing-asset.css')
      end

      assert_equal(
        'The asset "missing-asset.css" is not present in the asset manifest',
        exception.message
      )
    end

    def test_compute_asset_path_with_fallback
      config = Configuration.new
      config.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)
      config.fall_back_to_sprockets = true
      ExternalAssetPipeline.manifest = Manifest.new(config)

      assert_equal '/packs/application-7b3dc2436f7956c77987.js',
                   view.compute_asset_path('application.js')
      assert_equal '/packs/application-2ea8c3891d.css',
                   view.compute_asset_path('application.css')
      assert_equal 'fallback_missing-asset.css',
                   view.compute_asset_path('missing-asset.css')
    end

    def test_compute_asset_path_with_host
      config = Configuration.new
      config.dev_server.host = 'localhost'
      config.dev_server.port = 9555
      server_stub = ServerDouble.new(config.dev_server)
      server_stub.running = true

      ExternalAssetPipeline.manifest =
        ServerManifest.new(config: config, server: server_stub)

      options = {}
      assert_equal '/packs/application-from-server.js',
                   view.compute_asset_path('application.js', options)
      assert_equal 'http://localhost:9555', options[:host]

      options = {}
      assert_equal '/packs/application-from-server.css',
                   view.compute_asset_path('application.css', options)
      assert_equal 'http://localhost:9555', options[:host]

      options = {}
      exception = assert_raises(ExternalAssetPipeline::AssetNotFound) do
        view.compute_asset_path('missing-asset.css', options)
      end

      assert_nil options[:host]
      assert_equal(
        'The asset "missing-asset.css" is not present in the asset manifest',
        exception.message
      )
    end

    private

    module FallbackStub
      def compute_asset_path(source, _options)
        "fallback_#{source}"
      end
    end

    class ViewStub
      include FallbackStub
      include ExternalAssetPipeline::Helper
    end

    def view
      ViewStub.new
    end
  end
end
