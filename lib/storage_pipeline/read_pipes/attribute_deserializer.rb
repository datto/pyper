require 'json'

module StoragePipeline::ReadPipes
  # @param [Hash<Symbol, Class>] A map from field names to types. fields will be deserialized according to these types.
  class AttributeDeserializer < Struct.new(:type_mapping)
    # @param [Enumerable<Hash>] A list of items
    # @return [Enumerable<Hash>] A list of items, deserialized according to the type mapping
    def pipe(items, status)
      items.each do |item|
        type_mapping.each do |field, type|
          if item[field]
            item[field] = deserialize(item[field], type)
          end
        end
      end
      items
    end

    def deserialize(value, type)
      if (type == Array) || (type == Hash) then JSON.parse(value)
      elsif (type == Integer) then value.to_i
      elsif (type == Fixnum) then value.to_f
      else value end
    end
  end
end
