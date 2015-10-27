module Pyper::ReadPipes
  # Typically at the end of a pipeline, makes sure any lazy computations on the items are evaluated.
  # Returning a lazy enumerator can be unexpected by the consumer, and may cause the enumerator to
  # be evaluated more than once with unexpected results.
  class ForceEnumerator
    # @param items [Enumerable::Lazy<Hash>] A list of items
    # @param status [Hash] The mutable status field
    # @return [Enumerable<Hash>] A list of items, deserialized according to the type mapping
    def self.pipe(items, status = {})
      items.force
    end
  end
end
