module Pyper::WritePipes
  class AttributeValidation

    # Raised when validation fails.
    class Failure < ::StandardError; end

    # An Array of presence validations to perform.
    attr_reader :presence_validations

    # An Hash of inclusion validations to perform.
    attr_reader :inclusion_validations

    # An Array of whitelisted attributes that may be set.
    attr_reader :whitelist

    # @param opts [Hash] Options defining how attributes should be validated.
    # @option opts [Array<Symbol>] :presence Specifies a list of attributes for which
    #   presence validations should be performed. If any attribute in the provided list
    #   is nil or missing, a Failure error will be raised.
    # @option opts [Hash] :inclusion Specifies attributes for which inclusion
    #   validations should be performed. Each key in the Hash should represent an
    #   attribute to validate and should point to an Array of valid values. If the
    #   actual value at that key is not included in the list of valid values,
    #   a Failure error will be raised.
    # @option opts [Array<Symbol>] :whitelist If present, only allow the attributes
    #   in the whitelist Array be set. If not present, allow all attributes to be
    #   set.
    def initialize(opts={})
      @presence_validations = opts[:presence] || []
      @inclusion_validations = opts[:inclusion] || []
      @whitelist = opts[:whitelist]
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

      if whitelist.present?
        attributes.keys.each do |attr|
          unless whitelist.include?(attr)
            raise Failure.new("Attribute #{attr} is not allowed.")
          end
        end
      end

      attributes
    end
  end
end
