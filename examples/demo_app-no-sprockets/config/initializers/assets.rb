# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

module ExternalAssetPipelineExtension
  class SassProcessor
    def self.asset_path(path, _options = {})
      asset = ExternalAssetPipeline.manifest.find(JSON.parse(path.to_s))

      if asset
        Sass::Script::String.new("#{asset}", :string)
      else
        raise "Unrecognized sass_asset_path path argument: #{path}"
      end
    end
  end
end

# Temporarily patch the Sprockets SassProcessor to be able to resolve `img-url`
# function parameters to gulp-compiled image paths. This will go away once
# stylesheets are also processed outside of sprockets
module Sprockets
  class SassProcessor
    module Functions
      def asset_path(path, options = {})
        ExternalAssetPipelineExtension::SassProcessor.asset_path(path, options)
      end
    end
  end
end
