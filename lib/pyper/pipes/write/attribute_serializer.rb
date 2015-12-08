require 'json'

module Pyper::Pipes::Write
  # Provides a way to serialize attributes to JSON.
  class AttributeSerializer

    # @param attributes [Hash] Unserialized attributes
    # @param status [Hash] The mutable status field
    # @return [Hash] The serialized attributes
    def pipe(attributes, status = {})
      attributes.each_with_object({}) do |attr, serialized_attrs|
        value = force_encode_to_UTF8(attr.last)
        serialized_attrs[attr.first] = case value
                                       when Array, Hash then JSON.generate(value)
                                       when DateTime then value.to_time
                                       else value
                                       end
      end
    end

    def force_encode_to_UTF8(value)
      case value
      when Array
        value.map { |v| force_encode_to_UTF8(v) }
      when Hash
        Hash[value.map { |k,v| [k, force_encode_to_UTF8(v)] }]
      when String
        value.dup.force_encoding('UTF-8')
      else
        value
      end
    end
  end
end
