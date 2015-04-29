require 'json'

module StoragePipeline::WritePipes
  class AttributeSerializer
    def pipe(attributes, status = {})
      attributes.each_with_object({}) do |attr, serialized_attrs|
        value = attr.last
        serialized_attrs[attr.first] = case value
                                       when Array, Hash then JSON.generate(value)
                                       when DateTime then value.to_time
                                       else value
                                       end
      end
    end
  end
end
