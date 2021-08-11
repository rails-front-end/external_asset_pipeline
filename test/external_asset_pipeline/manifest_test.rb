# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/logger_double'
require 'external_asset_pipeline/manifest'

module ExternalAssetPipeline
  class ManifestTest < Minitest::Test
    TEST_APP_PUBLIC_PATH = File.expand_path('../test_app/public', __dir__)

    def test_find
      config = Configuration.new
      config.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)

      manifest = Manifest.new(config)

      assert_equal '/packs/application-7b3dc2436f7956c77987.js',
                   manifest.find('application.js')[:path]
      assert_equal '/packs/application-2ea8c3891d.css',
                   manifest.find('application.css')[:path]
      assert_nil manifest.find('missing-asset.css')
    end

    def test_find_when_manifest_values_include_prefix
      config = Configuration.new
      config.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)
      config.manifest_filename = 'manifest_with_prefixed_values.json'

      manifest = Manifest.new(config)

      # The assets prefix will always be prepended unless
      # `config.prepend_assets_prefix_to_manifest_values` is set to `false`
      assert_equal '/packs//packs/application-7b3dc2436f7956c77987.js',
                   manifest.find('application.js')[:path]
      assert_equal '/packs//packs/application-2ea8c3891d.css',
                   manifest.find('application.css')[:path]
      assert_nil manifest.find('missing-asset.css')

      config.prepend_assets_prefix_to_manifest_values = false

      assert_equal '/packs/application-7b3dc2436f7956c77987.js',
                   manifest.find('application.js')[:path]
      assert_equal '/packs/application-2ea8c3891d.css',
                   manifest.find('application.css')[:path]
      assert_nil manifest.find('missing-asset.css')
    end

    def test_find_when_manifest_file_does_not_exist
      config = Configuration.new
      config.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)
      config.manifest_filename = 'bogus_manifest.json'
      config.logger = LoggerDouble.new

      manifest = Manifest.new(config)
      assert_nil manifest.find 'application.js'

      expected_log_warning = "No file exists at path #{config.manifest_path}; "\
                             'treating it as an empty manifest'
      assert_equal [expected_log_warning], config.logger.messages
    end

    def test_manifest_caching
      config = Configuration.new
      config.public_path = Pathname.new(TEST_APP_PUBLIC_PATH)

      manifest = Manifest.new(config)

      assert_equal '/packs/application-7b3dc2436f7956c77987.js',
                   manifest.find('application.js')[:path]

      modify_application_js_fingerprint(config.manifest_path)

      assert_equal '/packs/application-7b3dc2436f7956c77987.js',
                   manifest.find('application.js')[:path]

      config.cache_manifest = false

      assert_equal '/packs/application-22222222222222222222.js',
                   manifest.find('application.js')[:path]

      revert_application_js_fingerprint(config.manifest_path)
    end

    def test_fall_back_to_sprockets
      config = Configuration.new
      manifest = Manifest.new(config)

      assert_equal false, manifest.fall_back_to_sprockets?

      config.fall_back_to_sprockets = true

      assert_equal true, manifest.fall_back_to_sprockets?
    end

    private

    def modify_application_js_fingerprint(manifest_path)
      `sed -i'.bak' -e 's/7b3dc2436f7956c77987/22222222222222222222/g' #{manifest_path}` # rubocop:disable Layout/LineLength
    end

    def revert_application_js_fingerprint(manifest_path)
      `sed -i'.bak' -e 's/22222222222222222222/7b3dc2436f7956c77987/g' #{manifest_path}` # rubocop:disable Layout/LineLength
      `rm #{manifest_path}.bak`
    end
  end
end
