module Pyper::Pipes
  # This pipe performs no operation. Usful if want to potentially skip a pipe in
  # in the pipeline.
  # @example
  #   (some condition) ? some_pipe(conent) : Pyper::Pipes::NoOp
  class NoOp

    # @param attrs_or_items [Object]
    # @param status [Hash] The mutable status field
    # @return [Object]
    def self.pipe(attrs_or_items, status = {})
      attrs_or_items
    end
  end
end
