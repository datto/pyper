module Pyper::WritePipes
  class CassandraWriter < Struct.new(:table_name, :client, :attribute_filter_set)
    def pipe(attributes, status = {})
      attributes_to_write = if attribute_filter_set
                              attributes.select { |k,v| attribute_filter_set.member?(k) }
                            else
                              attributes
                            end

      client.insert(table_name, attributes_to_write)
      attributes
    end
  end
end
