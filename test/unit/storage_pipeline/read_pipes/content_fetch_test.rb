require 'test_helper'

module StoragePipeline::ReadPipes
  class ContentFetchTest < Minitest::Should::TestCase
    context 'the content fetch pipe' do

      setup do
        @dir = Dir.mktmpdir
        @storage_builder = lambda do |attributes|
          StorageStrategy.get("#{@dir}/content",
            filters: [:size, :checksum],
            size: { metadata_key: :raw_size },
            checksum: {
              digest: :sha256,
              hash_type: :hex,
              metadata_key: :raw_sha256
            })
        end

        @pipe = ContentFetch.new(:content, &@storage_builder)
        @strategy = @storage_builder.call({})
      end

      should 'fetch content using the provided storage builder' do
        content = 'asdf'
        @strategy.write(content)

        attributes = @pipe.pipe({})
        assert_equal content, attributes[:content]
      end

      should 'add nothing if there is no content to store' do
        attributes = @pipe.pipe({})
        refute @content, attributes[:content]
      end
    end
  end
end
