module Pyper::Pipes
  # A generic pipe to remove fields from a pipeline
  class RemoveFields

    attr_reader :fields_to_remove

    # @param [Array] fields to be removed from pipe
    def initialize(fields_to_remove)
      @fields_to_remove = fields_to_remove
    end

    # @param [Enumerator] attributes in pipe
    # @return [Enumerator] items in pipe
    def pipe(attributes, status = {})
      fields_to_remove.each { |field| attributes.delete(field) }

      attributes
    end
  end
end