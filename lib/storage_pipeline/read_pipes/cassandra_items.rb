module StoragePipeline::ReadPipes
  class CassandraItems < Struct.new(:table, :client, :options)
    # @param [Hash] arguments
    # @option [Integer] limit
    # @option [Array] order A pair [clustering_column, :desc|:asc] determining how to order the results.
    # @option [Object] paging_state
    # @option [Integer] page_size
    # @return [Enumerator::Lazy<Hash>] enumerator of items
    def pipe(arguments, status)
      limit = arguments.delete(:limit)
      page_size = arguments.delete(:page_size)
      paging_state = arguments.delete(:paging_state)
      order = arguments.delete(:order)

      opts = (options || {}).merge({ page_size: page_size, paging_state: paging_state})

      query = client.select(table).where(arguments)
      query = query.limit(limit) if limit
      query = query.order(order.first, order.last) if order

      result = query.execute(opts)

      status[:paging_state] = result.paging_state
      status[:last_page] = result.last_page?

      result.rows.lazy
    end
  end
end
