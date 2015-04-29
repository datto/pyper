# StoragePipeline

Flexible pipelines for content storage and retrieval.

StoragePipeline allows the construction of pipelines to store and retrieve data. Each pipe in the pipeline modifies the
information in the pipeline before passing it to the next step. By composing pipes in different ways, different
data access patterns can be created.

## Usage

```

write_pipe = StoragePipeline::Pipeline.new <<
   StoragePipeline::WritePipes::AttributeSerializer.new <<
   StoragePipeline::Pipes::FieldRename.new(:to => :to_emails, :from => :from_email) <<
   StoragePipeline::Pipes::ModKey.new <<
   StoragePipeline::WritePipes::CassandraWriter.new(:table_1, metadata_client) <<
   StoragePipeline::WritePipes::CassandraWriter.new(:table_2, indexes_client) <<
   StoragePipeline::WritePipes::CassandraWriter.new(:table_3, indexes_client)

write_pipe.push(attributes)

read_pipe = StoragePipeline::Pipeline.new <<
   StoragePipeline::ReadPipes::PaginationDecoding.new <<
   StoragePipeline::ReadPipes::CassandraItems.new(:table, indexes_client) <<
   StoragePipeline::Pipes::FieldRename.new(:to_emails => :to, :from_email => :from) <<
   StoragePipeline::ReadPipes::VirtusDeserializer.new(message_attributes) <<
   StoragePipeline::ReadPipes::VirtusParser.new(MyModelClass)

result = read_pipe.push(:row => '1', :id => 'i')
result.value # Enumerator wich matching instances of MyModelClass
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'storage_pipeline'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install storage_pipeline

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/storage_pipeline/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
