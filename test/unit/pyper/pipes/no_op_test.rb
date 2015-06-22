require_relative '../../../test_helper'

module Pyper::Pipes
  class NoOpTest < Minitest::Should::TestCase
    context 'NoOp pipe' do
      should 'perform no operation' do
        pipe_input = { :pipe_var => "this is a string" }
        assert_equal pipe_input, NoOp.pipe(pipe_input)
      end
    end
  end
end
