require_relative '../../../test_helper'

module Pyper::ReadPipes
  class PaginationDecodingTest < Minitest::Should::TestCase
    setup do
      @pipe = PaginationDecoding.new
    end

    should 'decode the :paging_state argument' do
      decoded = 'sdf'
      encoded = Base64.urlsafe_encode64(decoded)

      args = {paging_state: encoded}
      new_attrs = @pipe.pipe(args)
      assert_equal decoded, new_attrs[:paging_state]
    end

    should 'allow missing paging states' do
      args = {}
      new_args = @pipe.pipe(args)
      assert_equal nil, new_args[:paging_state]
    end

    should 'not modify other args' do
      args = {other: 1}
      assert_equal args, @pipe.pipe(args)
    end
  end
end
