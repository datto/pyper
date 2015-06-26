require 'test_helper'
require 'json'

module Pyper::WritePipes
  class AttributeSerializerTest < Minitest::Should::TestCase
    setup do
      @pipe = AttributeSerializer.new
    end

    should 'serialize arrays to JSON' do
      value = [1,2,3]
      attributes = { :array => value }
      out = @pipe.pipe(attributes)
      assert_equal 1, out.count
      assert_equal JSON.generate(value), out[:array]
    end

    should 'serialize hashes to JSON' do
      value = {'a' => 1}
      attributes = { :hash => value }
      out = @pipe.pipe(attributes)
      assert_equal 1, out.count
      assert_equal JSON.generate(value), out[:hash]
    end

    should 'serialize datetimes to times' do
      value = DateTime.now
      attributes = { :datetime => value }
      out = @pipe.pipe(attributes)
      assert_equal 1, out.count
      assert_equal value.to_time, out[:datetime]
    end

    should 'encode strings to utf-8' do
      value = 'str'.force_encoding('UTF-8')
      attributes = { :string => value }
      out = @pipe.pipe(attributes)
      assert_equal 1, out.count
      assert_equal Encoding::UTF_8, out[:string].encoding
    end

    should 'not serialize other fields' do
      value = 1.5
      attributes = { :fixnum => value }
      out = @pipe.pipe(attributes)
      assert_equal 1, out.count
      assert_equal value, out[:fixnum]
    end
  end
end
