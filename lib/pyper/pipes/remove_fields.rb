module Pyper::Pipes
  # A generic pipe to remove fields from a pipeline
  class RemoveFields

    attr_reader :fields_to_remove

    # @param fields_to_remove [Array] fields to be removed from pipe
    def initialize(fields_to_remove)
      @fields_to_remove = Array.wrap(fields_to_remove)
    end

    # @param attributes [Hash] The attributes from which to remove the specified fields
    # @param status [Hash] The mutable status field
    # @return [Hash] attributes with the specified fields removed
    def pipe(attributes, status = {})
      attributes = attributes.dup
      fields_to_remove.each { |field| attributes.delete(field) }

      attributes
    end
  end
end
