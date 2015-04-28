module StoragePipeline::WritePipes
  class ContentStorage

    attr_reader :storage_field, :storage_strategy_builder
    def initialize(storage_field, &storage_strategy_builder)
      @storage_field = storage_field
      @storage_strategy_builder = storage_strategy_builder
    end

    def pipe(attributes, status = {})
      strategy = storage_strategy_builder.call(attributes)

      content = attributes.delete(storage_field)

      raise ArgumentError.new("#{storage_field} must be present in ContentStorage") unless content

      case content
      when NilClass then # do nothing -- there's no content to write
      when String then strategy.write(content)
      else strategy.write_from(content)
      end

      attributes.merge!(strategy.metadata)

      attributes
    end
  end
end
