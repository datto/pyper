require 'json'

module StoragePipeline::WritePipes
  class AttributeSerializer
    def pipe(attributes, options = {})
      attributes.each_with_object({}) do |attr, serialized_attrs|
        value = attr.last
        serialized_attrs[attr.first] = case value
                                       when Array, Hash then JSON.generate(value)
                                       else value
                                       end
      end
    end
  end
end
