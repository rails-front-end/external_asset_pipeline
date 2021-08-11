# frozen_string_literal: true

require 'json'

module ExternalAssetPipeline
  class Manifest
    def initialize(config)
      @config = config
    end

    def find(name)
      value = data[name.to_s]
      { path: "#{@config.manifest_value_prefix}#{value}" } if value
    end

    def fall_back_to_sprockets?
      @config.fall_back_to_sprockets?
    end

    private

    def data
      if @config.cache_manifest?
        @data ||= load
      else
        load
      end
    end

    def load
      JSON.parse(@config.manifest_path.read)
    rescue Errno::ENOENT
      warning = "No file exists at path #{@config.manifest_path}; "\
                'treating it as an empty manifest'
      @config.logger.warn warning
      {}
    end
  end
end
