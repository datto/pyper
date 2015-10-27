require 'json'

module Pyper::ReadPipes
  # @param type_mapping [Hash<Symbol, Class>] A map from field names to types. fields will be deserialized according
  # to these types.
  class AttributeDeserializer < Struct.new(:type_mapping)
    # @param items [Enumerable<Hash>] A list of items
    # @param status [Hash] The mutable status field
    # @return [Enumerable<Hash>] A list of items, deserialized according to the type mapping
    def pipe(items, status = {})
      items.map do |item|
        new_item = item.dup
        type_mapping.each do |field, type|
          new_item[field] = deserialize(new_item[field], type) if new_item[field]
        end
        new_item
      end
    end

    def deserialize(value, type)
      if (type == Array) || (type == Hash) then JSON.parse(value)
      elsif (type == Integer) then value.to_i
      elsif (type == Float) then value.to_f
      else value end
    end
  end
end
