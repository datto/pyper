module Pyper::Pipes::Read
  # Transform a series of items into model classes (based on Virtus model objects)
  # @param virtus_model_class [Class] the model class to instantiate. Should respond to `new(item_attributes)`
  class VirtusParser < Struct.new(:virtus_model_class)

    # @param items [Enumerable<Hash>]
    # @param status [Hash] The mutable status field
    # @return [Enumerable<Hash>] The unchanged list of items
    def pipe(items, status = {})
      items.map { |item| virtus_model_class.new(item) }
    end
  end
end
