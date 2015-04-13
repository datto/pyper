require 'test_helper'

module StoragePipeline::WritePipes
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
      end

      should 'store content using the provided storage builder' do
        content = 'asdf'
        pipe = ContentStorage.new(:content, &@storage_builder)
        pipe.pipe(:content => content)

        strategy = @storage_builder.call({})
        assert_equal content, strategy.read
      end


      should 'store size and checksum metadata' do
        content = 'asdf'
        pipe = ContentStorage.new(:content, &@storage_builder)
        pipe.pipe(:content => content)
        strategy = @storage_builder.call({})

        assert_equal '4', strategy.metadata[:raw_size]
        assert strategy.metadata[:raw_sha256]
      end

      should 'remove content from attributes adding new metadata fields' do
        content = 'asdf'
        pipe = ContentStorage.new(:content, &@storage_builder)
        attributes = pipe.pipe(:content => content)

        assert_equal '4', attributes[:raw_size]
        assert attributes[:raw_sha256]
      end
    end
  end
end
