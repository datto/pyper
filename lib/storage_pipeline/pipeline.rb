require_relative 'pipes/cassandra_writer'
require_relative 'pipes/attribute_serializer'
require_relative 'pipes/content_storage'

module StoragePipeline
  class Pipeline
    attr_reader :pipes
    def initialize(pipes = [])
      @pipes = pipes
    end

    def <<(pipe)
      pipes << pipe
      self
    end

    def store(input_attributes, options = {})
      pipes.inject(input_attributes) { |attributes, p| p.pipe(attributes, options) }
    end
  end
end
