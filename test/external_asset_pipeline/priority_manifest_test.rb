# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/manifest'
require 'external_asset_pipeline/priority_manifest'

module ExternalAssetPipeline
  class PriorityManifestTest < Minitest::Test
    TEST_APP_PUBLIC_PATH = File.expand_path('../test_app/public', __dir__)

    def setup
      @config1 = Configuration.new
      manifest1 = Manifest.new(@config1)

      @config2 = Configuration.new.configure { |c| c.assets_prefix = '/assets' }
      manifest2 = Manifest.new(@config2)

      config3 = Configuration.new
      config3.assets_prefix = '/assets'
      config3.manifest_filename = '.asset-manifest.json'
      manifest3 = Manifest.new(config3)

      path = Pathname.new(TEST_APP_PUBLIC_PATH)
      @config1.public_path = @config2.public_path = config3.public_path = path

      @priority_manifest = PriorityManifest.new(manifest1, manifest2, manifest3)
    end

    def test_find
      assert_equal '/packs/application-7b3dc2436f7956c77987.js',
                   @priority_manifest.find('application.js')[:path]
      assert_equal '/packs/application-2ea8c3891d.css',
                   @priority_manifest.find('application.css')[:path]
      assert_equal '/assets/foo-2nd-manifest.js',
                   @priority_manifest.find('foo.js')[:path]
      assert_equal '/assets/unique-3rd-manifest.css',
                   @priority_manifest.find('unique.css')[:path]
      assert_nil @priority_manifest.find('missing-asset.css')
    end

    def test_fall_back_to_sprockets
      assert_equal false, @priority_manifest.fall_back_to_sprockets?

      @config1.fall_back_to_sprockets = true

      assert_equal true, @priority_manifest.fall_back_to_sprockets?

      @config1.fall_back_to_sprockets = false

      assert_equal false, @priority_manifest.fall_back_to_sprockets?

      @config2.fall_back_to_sprockets = true

      assert_equal true, @priority_manifest.fall_back_to_sprockets?

      @config1.fall_back_to_sprockets = true

      assert_equal true, @priority_manifest.fall_back_to_sprockets?

      @config1.fall_back_to_sprockets = false
      @config2.fall_back_to_sprockets = false

      assert_equal false, @priority_manifest.fall_back_to_sprockets?
    end
  end
end
