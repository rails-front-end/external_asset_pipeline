# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'

module ExternalAssetPipeline
  class ConfigurationTest < Minitest::Test
    TEST_APP_PUBLIC_PATH = File.expand_path('../test_app/public', __dir__)

    def test_configure
      config = Configuration.new

      assert_equal '/packs', config.assets_prefix
      assert_equal true, config.cache_manifest
      assert_equal true, config.cache_manifest?
      assert_equal false, config.fall_back_to_sprockets
      assert_equal false, config.fall_back_to_sprockets?
      assert_equal 'manifest.json', config.manifest_filename
      assert_nil config.public_path

      result = config.configure do |c|
        c.assets_prefix = '/assets'
        c.cache_manifest = false
        c.fall_back_to_sprockets = true
        c.manifest_filename = '.revisioned-asset-manifest.json'
        c.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)
      end

      assert_equal config, result
      assert_equal '/assets', config.assets_prefix
      assert_equal false, config.cache_manifest
      assert_equal false, config.cache_manifest?
      assert_equal true, config.fall_back_to_sprockets
      assert_equal true, config.fall_back_to_sprockets?
      assert_equal '.revisioned-asset-manifest.json', config.manifest_filename
      assert_equal Pathname.new(TEST_APP_PUBLIC_PATH), config.public_path
    end

    def test_dev_server_settings
      config = Configuration.new

      assert_equal 0.01, config.dev_server.connect_timeout
      assert_nil config.dev_server.enabled
      assert_nil config.dev_server.host
      assert_nil config.dev_server.port

      config.configure do |c|
        c.dev_server.connect_timeout = 0.5
        c.dev_server.enabled = true
        c.dev_server.host = 'localhost'
        c.dev_server.port = 9000
      end

      assert_equal 0.5, config.dev_server.connect_timeout
      assert_equal true, config.dev_server.enabled
      assert_equal 'localhost', config.dev_server.host
      assert_equal 9000, config.dev_server.port
    end

    def test_manifest_path
      config = Configuration.new
      config.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)

      expected_manifest_path = Pathname.new(
        File.expand_path('../test_app/public/packs/manifest.json', __dir__)
      )

      assert_equal expected_manifest_path, config.manifest_path

      config.assets_prefix = '/assets'
      config.manifest_filename = '.revisioned-asset-manifest.json'

      expected_manifest_path = Pathname.new(
        File.expand_path(
          '../test_app/public/assets/.revisioned-asset-manifest.json',
          __dir__
        )
      )

      assert_equal expected_manifest_path, config.manifest_path
    end
  end
end
