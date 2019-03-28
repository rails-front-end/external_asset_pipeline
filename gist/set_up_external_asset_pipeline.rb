configuration = ExternalAssetPipeline::Configuration.new.configure do |config|
  config.cache_manifest = Rails.application.config.cache_revisioned_asset_manifest
  config.manifest_filename = '.revisioned-asset-manifest.json'
  config.public_path = Rails.root.join('public')
end
ExternalAssetPipeline.manifest = ExternalAssetPipeline::Manifest.new(configuration)

ActionView::Base.include ExternalAssetPipeline::Helper
