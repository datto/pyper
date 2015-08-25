require 'json'

module Pyper::WritePipes
  class AttributeSerializer
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
        result = {}
        value.each { |k, v| result[k] = force_encode_to_UTF8(v) }
        result
      when String
        value.dup.force_encoding('UTF-8')
      else
        value
      end
    end
  end
end
