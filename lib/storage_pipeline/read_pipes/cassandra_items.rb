module StoragePipeline::ReadPipes
  class CassandraItems < Struct.new(:table, :client)
    # @param [Hash] arguments
    def pipe(arguments = {}, options = {})
      limit = arguments.delete(:limit)

      query = client.select(table).where(arguments)
      query = query.limit(limit) if limit

      query.execute
    end
  end
end
