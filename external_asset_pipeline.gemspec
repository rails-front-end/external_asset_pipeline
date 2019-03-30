# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'external_asset_pipeline/version'

Gem::Specification.new do |s|
  s.name     = 'external_asset_pipeline'
  s.version  = ExternalAssetPipeline::VERSION
  s.authors  = ['Richard Macklin']
  s.email    = ['1863540+rmacklin@users.noreply.github.com']
  s.homepage = 'https://github.com/rails-front-end/external_asset_pipeline'
  s.license  = 'MIT'

  s.summary = 'Integrate an externally-managed asset pipeline with ActionView'
  s.description = <<~TEXT
    This gem provides a thin layer to connect an externally-managed asset
    pipeline to ActionView's AssetUrlHelper and AssetTagHelper methods. This is
    useful if you are comfortable leveraging other programs to produce an asset
    manifest and you just want it to integrate with ActionView's helper methods
    (e.g. `asset_path`, `javascript_include_tag`, etc.)
  TEXT

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] =
    "#{s.homepage}/tree/v#{ExternalAssetPipeline::VERSION}"
  s.metadata['changelog_uri'] =
    "#{s.homepage}/blob/v#{ExternalAssetPipeline::VERSION}/CHANGELOG.md"

  s.files = Dir['{lib}/**/*']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'railties', ['>= 5.0.0', '< 7.0']
end
