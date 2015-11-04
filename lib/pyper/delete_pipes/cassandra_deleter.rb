module Pyper::DeletePipes
  # Deletes from a specified cassandra table.

  # @param table_name [Symbol] The table in which to store the attributes
  # @param client [Cassava::Client] client to query cassandra with
  class CassandraDeleter < Struct.new(:table_name, :client)
    # @param args [Hash] Should contain the primary keys to delete. Can contain a :columns key to remove specific values.
    # @param status [Hash] The mutable status field
    # @return [Hash] The original attributes
    # @return [Cassandra::Result] the Cass result
  def pipe(arguments, status = {})
      columns = arguments.delete(:columns)

      statement = columns.present? ? client.delete(table_name, columns) : client.delete(table_name)
      result = statement.where(arguments).execute
    end
  end
end
