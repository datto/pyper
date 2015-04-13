module StoragePipeline::WritePipes
  class CassandraWriter < Struct.new(:table_name, :client)
    def pipe(attributes, options = {})
      client.insert(table_name, attributes)
      attributes
    end
  end
end
