module StoragePipeline::Pipes
  # For debugging purposes
  class Pry
    def pipe(items, status)
      binding.pry
      items
    end
  end
end
