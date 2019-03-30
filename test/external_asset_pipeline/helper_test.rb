# frozen_string_literal: true

require 'test_helper'

require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/manifest'
require 'external_asset_pipeline/helper'

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
