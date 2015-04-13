require_relative '../../../test_helper'

module StoragePipeline::WritePipes
  class CassandraWriterTest < Minitest::Should::TestCase
    context 'a cassandra writer pipe' do

      setup do
        setup_cass_schema

        @client = create_cass_client('test_datastore')
        @writer = CassandraWriter.new(:test, @client)
      end

      teardown do
        teardown_cass_schema
      end

      should 'write to the specified cassandra table' do
        attributes = {id: 'id', a: 'a', b: 'b'}
        @writer.pipe(attributes)
        row = @client.select(:test).execute.first

        attributes.keys.each do |key|
          assert_equal attributes[key], row[key.to_s]
        end
      end

      should 'raise an error if required attributes are not provided' do
        attributes = {a: 'a', b: 'b'}
        assert_raises(Cassandra::Errors::InvalidError) { @writer.pipe(attributes) }
      end

      should 'return the original attributes if the write succeeds' do
        attributes = {id: 'id', a: 'a', b: 'b'}
        assert_equal attributes, @writer.pipe(attributes)
      end
    end
  end
end
