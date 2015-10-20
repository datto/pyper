require_relative '../../../test_helper'

module Pyper::ReadPipes
  class PaginationEncodingTest < Minitest::Should::TestCase
    setup do
      @pipe = PaginationEncoding.new
    end

    should 'encode the :paging_state status' do
      state = 'sdf'
      encoded = Base64.urlsafe_encode64(state)

      status = {paging_state: state}
      @pipe.pipe([], status)
      assert_equal encoded, status[:paging_state]
    end

    should 'allow missing paging states' do
      status = {}
      @pipe.pipe([], status)
      assert_equal nil, status[:paging_state]
    end

    should 'not modify the items' do
      items = %w(a b)
      assert_equal items, @pipe.pipe(items, {})
    end
  end
end
