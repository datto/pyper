module Pyper::Pipes::Content
  # A pipe for storing content to an object store. Uses the StorageStrategy gem.
  class Store

    attr_reader :storage_field, :storage_strategy_builder

    # @param storage_field [Symbol] The attributes field in which the content is located.
    # @param storage_strategy_builder [Block] A block that takes an item and returns a StorageStrategy.
    def initialize(storage_field, &storage_strategy_builder)
      @storage_field = storage_field
      @storage_strategy_builder = storage_strategy_builder
    end

    # Stores content using the specified storage strategy
    # @param attributes [Hash] The attributes of the item for which content is to be stored
    # @param status [Hash] The mutable status field
    # @return [Hash] The item attributes, with the storage_field deleted.
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
