require_relative '../../../test_helper'

module Pyper::Pipes
  class FieldRenameTest < Minitest::Should::TestCase
    context 'the field rename pipe' do

      setup do
        @pipe = FieldRename.new(:a => :b, "c" => "d")
      end

      should 'rename provided symbols as symbols' do
        assert_equal({ :b => 1, :d => 1}, @pipe.pipe(:a => 1, :c => 1))
      end

      should 'rename provided strings as strings' do
        assert_equal({ "b" => 1, "d" => 1}, @pipe.pipe("a" => 1, "c" => 1))
      end

      should 'rename nil values' do
        assert_equal({ :b => nil, "d" => nil}, @pipe.pipe(:a => nil, "c" => nil))
      end
    end
  end
end
