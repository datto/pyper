module Pyper::ReadPipes

  # This pipe is for reading data from sharded rows in Cassandra. The table must have rows sharded by the 'mod_key' field.
  # For a fixed number of such shards, this pipe reads all data from all of those shards, returning a lazy enumerator
  # over all of those rows.
  # For example, if mod_size is 100, it will read the 100 rows with mod_key between 0 and 99.
  class CassModKeyEnumerator

    # @param [Symbol] the name of the cassandra table to fetch data from
    # @param [Cassava::Client]
    # @param [Integer] the mod size
    # @param [Integer] the page size
    attr_reader :table, :client, :mod_size, :page_size
    def initialize(table, client, mod_size = 100, page_size = 1000)
      @table = table
      @client = client
      @mod_size = mod_size
      @page_size = page_size
    end

    # @param [Hash] arguments
    # @return [Enumerator::Lazy<Hash>] enumerator of items from all rows
    def pipe(arguments, status = {})
      (Enumerator.new do |yielder|
         (0..mod_size).each do |mod_id|
           options = { :page_size => @page_size }
           paging_state = nil
           loop do
             options[:paging_state] = paging_state if paging_state.present?
             result = client.select(table).where(arguments.merge(:mod_key => mod_id)).execute(options)
             result.each { |item| yielder << item }

             break if result.last_page?
             paging_state = result.paging_state
           end
         end
       end).lazy
    end
  end
end
