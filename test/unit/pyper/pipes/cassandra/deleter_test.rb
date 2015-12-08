require 'test_helper'

module Pyper::Pipes::Cassandra
  class DeleterTest < Minitest::Should::TestCase
    context 'a cassandra delete pipe' do
      setup do
        setup_cass_schema

        @client = create_cass_client('test_datastore')
        @deleter = Deleter.new(:test, @client)
        @writer = Writer.new(:test, @client)
      end

      teardown do
        teardown_cass_schema
      end

      should 'delete from the specified table' do
        attributes = {id: 'id', a: 'a', b: 'b'}
        @writer.pipe(attributes)
        assert @client.select(:test).execute.first

        @deleter.pipe({:id => 'id'})
        refute @client.select(:test).execute.first
      end

      should 'delete certain columns' do
        attributes = {id: 'id', a: 'a', b: 'b'}
        @writer.pipe(attributes)
        assert_equal 'b', @client.select(:test).execute.first['b']

        @deleter.pipe({:id => 'id', :a => 'a', :columns => [:b]})
        refute @client.select(:test).execute.first['b']
      end
    end
  end
end
