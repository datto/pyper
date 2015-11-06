module Pyper::DeletePipes
  # Deletes from a specified cassandra table.

  # @param table_name [Symbol] The table from which to delete
  # @param client [Cassava::Client] client to query cassandra with
  class CassandraDeleter < Struct.new(:table_name, :client)
    # @param args [Hash] Should contain the primary keys to delete. Can contain a :columns key to remove specific values.
    # @param status [Hash] The mutable status field
    # @return [Hash] The original attributes
    def pipe(arguments, status = {})
      local_args = arguments.dup
      columns = local_args.delete(:columns)

      statement = columns.present? ? client.delete(table_name, columns) : client.delete(table_name)
      statement.where(local_args).execute
      arguments
    end
  end
end
