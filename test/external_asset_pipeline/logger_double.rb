# frozen_string_literal: true

module ExternalAssetPipeline
  class LoggerDouble
    attr_reader :messages

    def warn(message)
      @messages ||= []
      @messages << message
    end
  end
end
