module Pyper::Pipes
  # @param default_values [Hash] A hash of default values to set within the provided attrs if they are not already present.
  class DefaultValues < Struct.new(:default_values)

    # @param attrs [Hash] The attributes of the item
    # @param status [Hash] The mutable status field
    # @return [Hash] The item attributes with default values inserted
    def pipe(attrs, status = {})
      default_values.each do |field, value|
        attrs[field] = value unless attrs[field]
      end
      attrs
    end
  end
end
