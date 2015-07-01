module Pyper::WritePipes
  class AttributeValidation

    # Raised when a required attribute is missing.
    class FailedValidation < ::StandardError; end

    # An Array of required attributes.
    attr_reader :required_attributes

    # @param required_attributes [Array] A list of required attributes to check for.
    def initialize(required_attributes)
      @required_attributes = required_attributes

      unless @required_attributes.is_a?(Array)
        raise ArgumentError.new("Expected required_arguments to be an Array. Got #{required_attributes.class}")
      end
    end

    def pipe(attributes, status = {})
      required_attributes.each do |attr|
        raise FailedValidation.new("Missing required attribute #{attr}.") if attributes[attr].nil?
      end
      attributes
    end

  end
end
