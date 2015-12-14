require 'json'

module Pyper::Pipes::Model
  # Provides a way to deserialize serialized fields from an item. This is intended to be used with a Virtus
  # model class, and will use the attribute names and type information from that model to determine how to
  # deserialize.
  #
  # All serialization is as JSON.
  class VirtusDeserializer

    attr_reader :type_mapping

    # @param attribute_set [Virtus::AttributeSet] A Virtus AttributeSet
    def initialize(attribute_set)
      @type_mapping = Hash[attribute_set.map { |attr| [attr.name.to_s, attr.type.primitive] }]
    end

    # @param items [Enumerator<Hash>] A list of items
    # @param status [Hash] The mutable status field
    # @return [Enumerator<Hash>] A list of items, deserialized according to the type mapping
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
      if type == Array || type == Hash then JSON.parse(value)
      elsif type == Integer then value.to_i
      elsif type == Float then value.to_f
      else value end
    end
  end
end
