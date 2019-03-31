# frozen_string_literal: true

require 'json'

module ExternalAssetPipeline
  class PriorityManifest
    def initialize(*manifests)
      @manifests = manifests
    end

    def find(name)
      @manifests.lazy.map { |manifest| manifest.find name }.find(&:itself)
    end

    def fall_back_to_sprockets?
      @manifests.any?(&:fall_back_to_sprockets?)
    end
  end
end
