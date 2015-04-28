module StoragePipeline::ReadPipes
  class CassModKeyEnumerator

    # @param [Symbol] the name of the cassandra table to fetch data from
    # @param [Cassava::Client]
    # @param [Integer] the mod size
    attr_reader :table, :client, :mod_size
    def initialize(table, client, mod_size = 100)
      @table = table
      @client = client
      @mod_size = mod_size
    end

    # @param [Hash] arguments
    # @return [Enumerator::Lazy<Hash>] enumerator of items
    def pipe(arguments, status)
      (Enumerator.new do |yielder|
         (0..mod_size).each do |mod_id|
           result = client.select(table).where(arguments.merge(:mod_key => mod_id)).execute
           result.each { |item| yielder << item }
         end
       end).lazy
    end
  end
end
