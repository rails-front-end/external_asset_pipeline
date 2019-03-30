# frozen_string_literal: true

require 'external_asset_pipeline/version'

module ExternalAssetPipeline
  class Error < StandardError; end
  class AssetNotFound < Error; end

  class << self
    attr_accessor :manifest
  end
end
