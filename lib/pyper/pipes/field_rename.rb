module Pyper::Pipes
  # @param attr_map [Hash] A map of old field names to new field names, which will be used to rename attributes.
  class FieldRename < Struct.new(:attr_map)

    # @param args [Hash|Enumerator<Hash>] One or more item hashes
    # @param status [Hash] The mutable status field
    # @return [Hash|Enumerator<Hash>] The item(s) with fields renamed
    def pipe(attrs_or_items, status = {})
      case attrs_or_items
      when Hash then rename(attrs_or_items)
      else attrs_or_items.map { |item| rename(item) }
      end
    end

    def rename(item)
      attr_map.each do |old,new|
        item[new.to_sym] = item.delete(old.to_sym) if item.has_key?(old.to_sym)
        item[new.to_s] = item.delete(old.to_s) if item.has_key?(old.to_s)
      end
      item
    end
  end
end
