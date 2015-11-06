require_relative 'write_pipes/cassandra_writer'
require_relative 'write_pipes/attribute_serializer'
require_relative 'write_pipes/attribute_validation'
require_relative 'write_pipes/content_storage'

require_relative 'read_pipes/content_fetch'
require_relative 'read_pipes/cassandra_items'
require_relative 'read_pipes/attribute_deserializer'
require_relative 'read_pipes/virtus_deserializer'
require_relative 'read_pipes/virtus_parser'
require_relative 'read_pipes/cass_mod_key_enumerator'
require_relative 'read_pipes/pagination_decoding'
require_relative 'read_pipes/pagination_encoding'
require_relative 'read_pipes/force_enumerator'

require_relative 'delete_pipes/cassandra_deleter'

# pipes that can be used for both reading and writing
require_relative 'pipes/mod_key'
require_relative 'pipes/field_rename'
require_relative 'pipes/default_values'
require_relative 'pipes/no_op'
require_relative 'pipes/remove_fields'

module Pyper

  class PipeStatus < Struct.new(:value, :status); end

  class Pipeline
    class << self
      def create
        new.tap do |pl|
          pl.instance_eval &Proc.new if block_given?
        end
      end
    end

    attr_reader :pipes

    def initialize(pipes = [])
      @pipes = pipes
    end

    # @param pipe [#pipe|#call] A pipe to append to the pipeline
    def <<(pipe)
      pipes << pipe
      self
    end

    alias_method :add, :<<

    # Insert something into the pipeline to be processed
    # @param input [Object] The original input data to enter the pipeline. This may be mutated by each pipe in the pipeline.
    # @return [PipeStatus] the pipe status, containing both the value and a status hash.
    def push(input)
      status = {}
      value = pipes.inject(input) do |attributes, p|
        if p.respond_to?(:call)
          p.call(attributes, status)
        else
          p.pipe(attributes, status)
        end
      end

      PipeStatus.new(value, status)
    end
  end
end
