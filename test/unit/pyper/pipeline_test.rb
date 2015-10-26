require 'test_helper'

module Pyper
  class PipelineTest < Minitest::Should::TestCase
    context '::create' do
      context 'with a block' do
        should 'yield the instance to the block' do
          el = 'hello'

          pl = Pyper::Pipeline.create do
            add el
          end

          assert pl.pipes.include? el
        end

        should 'return a new pipeline' do
          pl = Pyper::Pipeline.create do
            add 'hello'
          end

          assert pl.is_a? Pyper::Pipeline
        end
      end

      context 'without a block' do
        should 'return a new pipeline' do
          pl = Pyper::Pipeline.create

          assert pl.is_a? Pyper::Pipeline
        end
      end
    end

    context '#add' do
      should 'add the pipe to the pipes' do
        pl = Pyper::Pipeline.new
        el = 'hello'
        pl.add el

        assert pl.pipes.include? el
      end
    end
  end
end
