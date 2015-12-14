require 'base64'

module Pyper::Pipes::Cassandra
  # This pipe extracts an encoded paging_state, decodes it, and passes on a decoded
  # paging state.
  # This pipe is intended to be used before the Cassandra::Reader pipe, as that pipe
  # can interpret the :paging_state argument.
  #
  # This pipe pairs with the PaginationEncoding pipe, which performs the reverse
  # transformation
  class PaginationDecoding

    # @param args [Hash] Arguments that include an encoded :paging_state
    # @param status [Hash] The mutable status field
    # @return [Hash] The list of arguments with :paging_state decoded, if present
    def pipe(args, status = {})
      page_state = args[:paging_state]
      args[:paging_state] = Base64.urlsafe_decode64(page_state) if page_state
      args
    end
  end
end
