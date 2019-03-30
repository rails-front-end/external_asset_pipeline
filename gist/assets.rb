# config/initializers/assets.rb

module ExternalAssetPipeline
  mattr_accessor :manifest

  class Manifest
    def initialize(config)
      @config = config
    end

    def find(name)
      value = data[name.to_s]
      "#{@config.assets_prefix}/#{value}" if value
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
    end
  end
end
