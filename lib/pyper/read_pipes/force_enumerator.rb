module Pyper::ReadPipes
  # Typically at the end of a pipeline, makes sure any lazy computations on the items are evaluated.
  # Returning a lazy enumerator can be unexpected by the consumer, and may cause the enumerator to
  # be evaludated more than once with unexpected results.
  class ForceEnumerator
    def self.pipe(items, status = {})
      items.force
    end
  end
end
