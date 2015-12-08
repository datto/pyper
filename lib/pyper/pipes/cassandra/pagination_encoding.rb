require 'base64'

module Pyper::Pipes::Cassandra
  # Given a :paging_state in the status field, encodes it. This is the reverse transformation of
  # the PaginationDecoding pipe.
  class PaginationEncoding

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
