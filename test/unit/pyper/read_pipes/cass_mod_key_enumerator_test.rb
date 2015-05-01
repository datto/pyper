require_relative '../../../test_helper'

module Pyper::ReadPipes
  class CassModKeyEnumeratorTest < Minitest::Should::TestCase
    context 'a cassandra reader pipe' do

      setup do
        setup_cass_schema

        @client = create_cass_client('test_datastore')
        @pipe = CassModKeyEnumerator.new(:mod_test, @client, mod_size = 4)

        # populate some test data
        @client.insert(:mod_test, {row: 1, id: 'ida', mod_key: 0, val: '1'})
        @client.insert(:mod_test, {row: 1, id: 'idb', mod_key: 1, val: '2'})
        @client.insert(:mod_test, {row: 1, id: 'idc', mod_key: 2, val: '3'})
      end

      teardown do
        teardown_cass_schema
      end

      should 'return all items in an unordered enumerator from cassandra' do
        result = @pipe.pipe(row: 1).to_a
        assert_equal 3, result.size
        assert_equal %w(1 2 3).to_set, result.map { |i| i['val'] }.to_set
      end

      should 'not return items with a mod key outside the mod key range' do
        @client.insert(:mod_test, {row: 1, id: 'idz', mod_key: 99, val: '1'})
        result = @pipe.pipe(row: 1).to_a
        assert_equal 3, result.size
      end
    end
  end
end
