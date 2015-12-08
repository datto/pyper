require_relative 'pipes'

module Pyper

  class PipeStatus < Struct.new(:value, :status); end

  class Pipeline
    class << self

      # Provides an interface for creating a pipeline. The provided block will be called
      # in the context of a newly-created pipeline, to which pipes can be added using #add.
      # @return [Pyper::Pipeline] The created pipeline.
      def create(&block)
        new.tap do |pipeline|
          if block_given?
            original_self = eval('self', block.binding)
            pipeline.instance_variable_set(:@original_self, original_self)
            pipeline.instance_eval(&block)
            pipeline.remove_instance_variable(:@original_self)
          end
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

    def method_missing(sym, *args, &block)
      @original_self ? @original_self.send(sym, *args, &block) : super
    end

    def respond_to_missing?(sym, include_all = false)
      @original_self ? @original_self.respond_to?(sym, include_all) : super
    end
  end
end
