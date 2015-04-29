module StoragePipeline::ReadPipes
  class CassandraItems < Struct.new(:table, :client, :options)
    # @param [Hash] arguments
    # @return [Enumerator::Lazy<Hash>] enumerator of items
    def pipe(arguments, status)
      limit = arguments.delete(:limit)
      page_size = arguments.delete(:page_size)
      paging_state = arguments.delete(:paging_state)

      opts = (options || {}).merge({ page_size: page_size, paging_state: paging_state})

      query = client.select(table).where(arguments)
      query = query.limit(limit) if limit

      result = query.execute(opts)

      status[:paging_state] = result.paging_state
      status[:last_page] = result.last_page?

      result.rows.lazy
    end
  end
end
