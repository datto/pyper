module StoragePipeline::Pipes
  class DefaultValues < Struct.new(default_values)
    def pipe(attrs, status)
      default_values.each do |field, value|
        attrs[field] = value unless attrs[field]
      end
      attrs
    end
  end
end
