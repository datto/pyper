module StoragePipeline::Pipes
  class CassandraWriter < Struct.new(:table_name, :client)
    def pipe(attributes, options = {})
      client.insert(table_name, attributes)
    end
  end
end
