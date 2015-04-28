module StoragePipeline::ReadPipes
  class ContentFetch

    attr_reader :storage_field, :storage_strategy_builder
    def initialize(storage_field, &storage_strategy_builder)
      @storage_field = storage_field
      @storage_strategy_builder = storage_strategy_builder
    end

    def pipe(attributes, options = {})
      strategy = storage_strategy_builder.call(attributes)
      content =
        begin
          strategy.read
        rescue Errno::ENOENT
          nil
        end
      attributes.merge!(storage_field => content)
    end
  end
end
