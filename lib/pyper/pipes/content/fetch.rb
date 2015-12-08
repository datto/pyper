module Pyper::Pipes::Content
  class Fetch

    attr_reader :storage_field, :storage_strategy_builder

    # @param storage_field [Symbol] For each item hash, the field in which to insert the content
    # @param storage_strategy_builder [Block] A block that takes an item and returns a StorageStrategy.
    def initialize(storage_field, &storage_strategy_builder)
      @storage_field = storage_field
      @storage_strategy_builder = storage_strategy_builder
    end

    # @param items [Enumerable<Hash>] A list of items
    # @param status [Hash] The mutable status field
    # @return [Enumerable<Hash>] The items, with the retrieved content inserted in the storage field
    def pipe(items, status = {})
      items.map do |item|
        strategy = storage_strategy_builder.call(item)

        content =
          begin
            strategy.read
          rescue Errno::ENOENT, StorageStrategy::NotFound
            nil
          end
        item.merge(storage_field => content)
      end
    end
  end
end
