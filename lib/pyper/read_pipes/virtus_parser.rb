module Pyper::ReadPipes
  # Transform a series of items into model classes (based on Virtus model objects)
  # @param [Class] the model class to instantiate. Should respond to `new(item_attributes)`
  class VirtusParser < Struct.new(:virtus_model_class)
    # @param [Enumerator<Hash>] items
    def pipe(items, status = {})
      items.map { |item| virtus_model_class.new(item) }
    end
  end
end
