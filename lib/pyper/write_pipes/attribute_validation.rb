module Pyper::WritePipes
  class AttributeValidation

    # Raised when validation fails.
    class Failure < ::StandardError; end

    # An Array of attributes that are allowed to be set. If empty, all attributes
    # are allowed.
    attr_reader :allowed

    # An Array of attributes that are required to be set.
    attr_reader :required

    # An Hash of attributes whose value must be restricted to a set of valid values.
    # Format :attribute => VALID_VALUES.
    attr_reader :restricted

    # @param opts [Hash] Options defining how attributes should be validated.
    # @option opts [Array<Symbol>] :allowed A list of attributes that are allowed
    #   to be set. If empty, all attributes are assumed to be allowed.
    # @option opts [Array<Symbol>] :required A list of attributes that are required
    #   to be set.
    # @option opts [Hash] :restricted A hash of attributes whose value must be
    #   restricted to a set of valid values. Format :attribute => VALID_VALUES.
    def initialize(opts={})
      @allowed = opts[:allowed]
      @required = opts[:required] || []
      @restricted = opts[:restricted] || {}
    end

    def pipe(attributes, status = {})
      required.each do |attr|
        if attributes[attr].nil?
          raise Failure.new("Missing required attribute #{attr}.")
        end
      end

      restricted.each do |attr, valid_values|
        unless valid_values.include?(attributes[attr])
          raise Failure.new("Invalid value for attribute #{attr}.")
        end
      end

      if allowed.present?
        attributes.keys.each do |attr|
          unless allowed.include?(attr)
            raise Failure.new("Attribute #{attr} is not allowed.")
          end
        end
      end

      attributes
    end
  end
end
