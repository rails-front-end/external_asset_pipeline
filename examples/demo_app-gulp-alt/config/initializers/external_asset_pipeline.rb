DemoApp.external_asset_pipeline_manifest =
  ExternalAssetPipeline::PriorityManifest.new(
    ExternalAssetPipeline::Manifest.new(
      Rails.application.config.external_asset_pipeline.dup.configure do |config|
        config.manifest_filename = 'webpack-manifest.json'
      end
    ),
    ExternalAssetPipeline::Manifest.new(
      Rails.application.config.external_asset_pipeline.dup.configure do |config|
        config.manifest_filename = 'gulp-manifest.json'
      end
    )
  )
