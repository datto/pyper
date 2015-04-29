require 'base64'

module StoragePipeline::ReadPipes
  # @param [Hash<Symbol, Class>] A map from field names to types. fields will be deserialized according to these types.
  class PaginationEncoding

    def pipe(items, status)
      page_state = status[:paging_state]
      status[:paging_state] = Base64.urlsafe_encode64(page_state) if page_state
      items
    end
  end
end
