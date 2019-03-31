# frozen_string_literal: true

require 'rails/railtie'

require 'external_asset_pipeline'
require 'external_asset_pipeline/configuration'
require 'external_asset_pipeline/dev_server'
require 'external_asset_pipeline/helper'
require 'external_asset_pipeline/manifest'
require 'external_asset_pipeline/priority_manifest'
require 'external_asset_pipeline/server_manifest'

module ExternalAssetPipeline
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      config.external_asset_pipeline = Configuration.new.configure do |c|
        c.public_path = ::Rails.root.join('public')
      end
    end

    config.after_initialize do
      ExternalAssetPipeline.manifest =
        if config.external_asset_pipeline.dev_server.enabled
          PriorityManifest.new(
            ServerManifest.new(
              config: config.external_asset_pipeline,
              server: DevServer.new(config.external_asset_pipeline.dev_server)
            ),
            Manifest.new(config.external_asset_pipeline)
          )
        else
          Manifest.new(config.external_asset_pipeline)
        end

      ActiveSupport.on_load(:action_view) do
        include ExternalAssetPipeline::Helper
      end
    end
  end
end
