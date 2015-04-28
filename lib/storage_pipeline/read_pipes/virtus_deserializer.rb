require 'json'

module StoragePipeline::ReadPipes
  # @param [Hash<Symbol, Class>] A map from field names to types. fields will be deserialized according to these types.
  class VirtusDeserializer

    attr_reader :type_mapping

    # @ param [Virtus::AttributeSet] A Virtus AttributeSet
    def initialize(attribute_set)
      @type_mapping = Hash[attribute_set.map { |attr| [attr.name, attr.type] }]
    end

    # @param [Enumerator<Hash>] A list of items
    # @return [Enumerator<Hash>] A list of items, deserialized according to the type mapping
    def pipe(items, status)
      items.map do |item|
        type_mapping.each do |field, virtus_type|
          item[field] = deserialize(item[field], type)  if item[field]
        end
      end
      items
    end

    def deserialize(value, virtus_type)
      if virtus_type.include?(Array) || virtus_type.include?(Hash) then JSON.parse(value)
      elsif virtus_type.include?(Integer) then value.to_i
      elsif virtus_type.include?(Fixnum) then value.to_f
      else value end
    end
  end
end
