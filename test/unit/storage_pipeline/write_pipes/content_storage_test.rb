require 'test_helper'

module Pyper::WritePipes
  class ContentStorageTest < Minitest::Should::TestCase
    context 'the content storage pipe' do

      setup do
        @dir = Dir.mktmpdir
        @storage_builder = lambda do |attributes|
          StorageStrategy.get("#{@dir}/metadata",
            filters: [:size, :checksum],
            size: { metadata_key: :raw_size },
            checksum: {
              digest: :sha256,
              hash_type: :hex,
              metadata_key: :raw_sha256
            })
        end

        @pipe = ContentStorage.new(:content, &@storage_builder)
        @strategy = @storage_builder.call({})
      end

      should 'store content using the provided storage builder' do
        content = 'asdf'
        @pipe.pipe(:content => content)

        assert_equal content, @strategy.read
      end


      should 'store size and checksum metadata' do
        content = 'asdf'
        @pipe.pipe(:content => content)

        assert_equal '4', @strategy.metadata[:raw_size]
        assert @strategy.metadata[:raw_sha256]
      end

      should 'remove content from attributes adding new metadata fields' do
        content = 'asdf'
        attributes = @pipe.pipe(:content => content)

        assert_equal '4', attributes[:raw_size]
        assert attributes[:raw_sha256]
      end
    end
  end
end
