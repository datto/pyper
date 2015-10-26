require 'base64'

module Pyper::ReadPipes
  class PaginationEncoding

    # Given a :paging_state in the status field, deserializes it. This is the reverse transformation of
    # the PaginationDecoding pipe.
    # @param items [Enumerable<Hash>]
    # @param status [Hash] The mutable status field
    # @return [Enumerable<Hash>] The unchanged list of items
    def pipe(items, status)
      page_state = status[:paging_state]
      status[:paging_state] = Base64.urlsafe_encode64(page_state) if page_state
      items
    end
  end
end
