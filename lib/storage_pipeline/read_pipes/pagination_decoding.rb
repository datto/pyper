require 'base64'

module StoragePipeline::ReadPipes
  class PaginationDecoding

    def pipe(args, status = {})
      page_state = args[:paging_state]
      args[:paging_state] = Base64.urlsafe_decode64(page_state) if page_state
      args
    end
  end
end
