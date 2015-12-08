require 'test_helper'
require 'json'
require 'virtus'

module Pyper::Pipes::Read
  class VirtusDeserializerTest < Minitest::Should::TestCase

    class TestVirtus
      include ::Virtus.model

      attribute :array, Array[String]
      attribute :hash, Hash
      attribute :int, Integer
      attribute :float, Float
      attribute :other, String
    end

    setup do
      @pipe = VirtusDeserializer.new(TestVirtus.attribute_set)
    end

    should 'deserialize json arrays' do
      value = [1,2,3]
      item = { 'array' => JSON.generate(value) }
      out = @pipe.pipe([item])
      assert_equal 1, out.count

      assert_equal value, out.first['array']
    end

    should 'deserialize json hashes' do
      value = {'a' => 1}
      item = { 'hash' => JSON.generate(value) }
      out = @pipe.pipe([item])
      assert_equal 1, out.count
      assert_equal value, out.first['hash']
    end

    should 'deserialize ints' do
      value = 1
      item = { 'int' => value.to_s }
      out = @pipe.pipe([item])
      assert_equal 1, out.count
      assert_equal value, out.first['int']
    end

    should 'deserialize floats' do
      value = 1.5
      item = { 'float' => value.to_s }
      out = @pipe.pipe([item])
      assert_equal 1, out.count
      assert_equal value, out.first['float']
    end

    should 'not deserialize other fields' do
      value = 'asdf'
      item = { 'other' => value }
      out = @pipe.pipe([item])
      assert_equal 1, out.count
      assert_equal value, out.first['other']
    end

    should 'not modify original values when deserializng' do
      value = [1,2,3]
      item = { 'array' => JSON.generate(value) }
      out = @pipe.pipe([item])
      assert_equal 1, out.count
      assert_equal value, out.first['array']

      # This throws an error if we have modified the original values
      out = @pipe.pipe([item])
      assert_equal value, out.first['array']
    end
  end
end
