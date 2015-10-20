require 'test_helper'

module Pyper::Pipes
  class RemoveFieldsTest < Minitest::Should::TestCase
    context 'the remove fields pipe' do

      should "accept a symbol" do
        pipe = RemoveFields.new(:a)
        assert_equal({ :b => 2 }, pipe.pipe(:a => 1, :b => 2))
      end

      should "accept an array of  symbol" do
        pipe = RemoveFields.new([:a])
        assert_equal({ :b => 2 }, pipe.pipe(:a => 1, :b => 2))
      end

      should 'remove fields provided an array of symbols' do
        pipe = RemoveFields.new([:a])
        assert_equal({ :b => 2 }, pipe.pipe(:a => 1, :b => 2))
      end

    end
  end
end
