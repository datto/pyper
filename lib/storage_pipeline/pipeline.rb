require_relative 'write_pipes/cassandra_writer'
require_relative 'write_pipes/attribute_serializer'
require_relative 'write_pipes/content_storage'

require_relative 'read_pipes/content_fetch'
require_relative 'read_pipes/cassandra_items'
require_relative 'read_pipes/attribute_deserializer'

module StoragePipeline

  class Pipeline
    attr_reader :pipes
    def initialize(pipes = [])
      @pipes = pipes
    end

    # @param [#pipe] A pipe to append to the pipeline
    def <<(pipe)
      pipes << pipe
      self
    end

    # Insert something into the pipeline to be processed
    # @param [Object] The original input data to enter the pipeline. This may be mutated by each pipe in the pipeline.
    # @param [Hash] An immutable set of options for this insert.
    def insert(input, options = {})
      pipes.inject(input) { |attributes, p| p.pipe(attributes, options.dup) }
    end
  end
end
