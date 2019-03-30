# frozen_string_literal: true

require 'rails/railtie'

require 'external_asset_pipeline'
require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/helper'
require 'external_asset_pipeline/manifest'

module ExternalAssetPipeline
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      config.external_asset_pipeline = Configuration.new.configure do |c|
        c.public_path = ::Rails.root.join('public')
      end
    end

    config.after_initialize do
      ExternalAssetPipeline.manifest =
        Manifest.new(config.external_asset_pipeline)

      ActiveSupport.on_load(:action_view) do
        include ExternalAssetPipeline::Helper
      end
    end
  end
end
