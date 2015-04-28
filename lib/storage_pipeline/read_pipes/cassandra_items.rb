module StoragePipeline::ReadPipes
  class CassandraItems < Struct.new(:table, :client, :options)
    # @param [Hash] arguments
    # @return [Enumerator::Lazy<Hash>] enumerator of items
    def pipe(arguments, status)
      limit = arguments.delete(:limit)

      query = client.select(table).where(arguments)
      query = query.limit(limit) if limit

      result = query.execute(options || {})

      status[:paging_state] = result.paging_state
      status[:last_page] = result.last_page?

      result.rows.lazy
    end
  end
end
