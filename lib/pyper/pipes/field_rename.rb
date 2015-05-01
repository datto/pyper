module Pyper::Pipes
  # @param [Hash] A map of old field names to new field names, which will be used to rename attributes.
  class FieldRename < Struct.new(:attr_map)
    def pipe(attrs_or_items, status = {})
      case attrs_or_items
      when Hash then rename(attrs_or_items)
      else attrs_or_items.map { |item| rename(item) }
      end
    end

    def rename(item)
      attr_map.each do |old,new|
        item[new] = item.delete(old) if item[old]
        item[new.to_s] = item.delete(old.to_s) if item[old.to_s]
      end
      item
    end
  end
end
