require_relative '../../../test_helper'

module Pyper::Pipes
  class NoOpTest < Minitest::Should::TestCase
    context 'NoOp pipe' do

      setup do
        @pipe = { :pipe_var => "this is a string" }
      end

      should 'perform no operation' do
        Pyper::Pipes::NoOp
        assert_equal({ :pipe_var => "this is a string" }, @pipe)
      end
    end
  end
end
