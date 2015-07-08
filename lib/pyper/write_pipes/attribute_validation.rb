module Pyper::WritePipes
  class AttributeValidation

    # Raised when validation fails.
    class Failure < ::StandardError; end

    # Array of attributes that are allowed to be set. If empty, all attributes
    # are allowed.
    attr_reader :allowed

    # Array of attributes that are required to be present (non-nil).
    attr_reader :required

    # Hash of attributes whose value must be restricted in some way.
    # Format :attribute => lambda { |value| #Return boolean indicating pass/fail }
    attr_reader :restricted

    # @param opts [Hash] Options defining how attributes should be validated.
    # @option opts [Array<Symbol>] :allowed A list of attributes that are allowed
    #   to be set. If empty, all attributes are assumed to be allowed.
    # @option opts [Array<Symbol>] :required A list of attributes that are required
    #   to be present (non-nil).
    # @option opts [Hash] :restricted A Hash of attributes whose value must be
    #   restricted in some way.
    #   Format :attribute => lambda { |value| #Return boolean indicating pass/fail }
    def initialize(opts={})
      @allowed = opts[:allowed] if opts[:allowed]
      @required = opts[:required] if opts[:required]
      @restricted = opts[:restricted]
    end

    def pipe(attributes, status = {})
      if allowed.present?
        attributes.keys.each do |attr|
          raise Failure.new("Attribute #{attr} is not allowed.") unless allowed.include?(attr)
        end
      end

      if required.present?
        required.each do |attr|
          raise Failure.new("Missing required attribute #{attr}.") if attributes[attr].nil?
        end
      end

      if restricted.present?
        restricted.each do |attr, test|
          raise Failure.new("Invalid value for attribute #{attr}.") unless test.call(attributes[attr])
        end
      end

      attributes
    end
  end
end
