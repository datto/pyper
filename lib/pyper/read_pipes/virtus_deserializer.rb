require 'json'

module Pyper::ReadPipes
  # @param [Hash<Symbol, Class>] A map from field names to types. fields will be deserialized according to these types.
  class VirtusDeserializer

    attr_reader :type_mapping

    # @ param [Virtus::AttributeSet] A Virtus AttributeSet
    def initialize(attribute_set)
      @type_mapping = Hash[attribute_set.map { |attr| [attr.name.to_s, attr.type.primitive] }]
    end

    # @param [Enumerator<Hash>] A list of items
    # @return [Enumerator<Hash>] A list of items, deserialized according to the type mapping
    def pipe(items, status)
      items.map do |item|
        type_mapping.each do |field, type|
          item[field] = deserialize(item[field], type) if item[field]
        end
        item
      end
    end

    def deserialize(value, type)
      if type == Array || type == Hash then JSON.parse(value)
      elsif type == Integer then value.to_i
      elsif type == Fixnum then value.to_f
      else value end
    end
  end
end
