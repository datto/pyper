module Pyper::WritePipes
  class AttributeValidation

    # Raised when validation fails.
    class Failure < ::StandardError; end

    # An Array of presence validations to perform.
    attr_reader :presence_validations

    # An Array of inclusion validations to perform.
    attr_reader :inclusion_validations

    # @param opts [Hash] Options defining how attributes should be validated.
    # @option opts [Array<Symbol>] :presence Specifies a list of attributes for which
    #   presence validations should be performed. If any attribute in the provided list
    #   is nil or missing, a Failure error will be raised.
    # @option opts [Array<Hash>] :inclusion Specifies a list of attributes for which
    #   inclusion validations should be performed. Each Hash in the list should 
    #   contain one key (the attribute) which points to an array of valid values.
    #   If the actual value at that key is not included in the list of valid values,
    #   a Failure error will be raised.
    def initialize(opts={})
      @presence_validations = opts[:presence] || []
      @inclusion_validations = opts[:inclusion] || []
    end

    def pipe(attributes, status = {})
      presence_validations.each do |attr|
        if attributes[attr].nil?
          raise Failure.new("Missing required attribute #{attr}.")
        end
      end

      inclusion_validations.each do |attr, valid_values|
        unless valid_values.include?(attributes[attr])
          raise Failure.new("Invalid value for attribute #{attr}.")
        end
      end

      attributes
    end
  end
end
