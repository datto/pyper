module StoragePipeline::ReadPipes
  class SingleItemReader < Struct.new(:table, :client)
    # @param [Hash]
    def pipe(arguments = {}, options = {})
      client.select(table).where(arguments).execute
    end
  end
end
