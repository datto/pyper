# StoragePipeline

Flexible pipelines for content storage and retrieval.

StoragePipeline allows the construction of pipelines to store and retrieve data. Each pipe in the pipeline modifies the
information in the pipeline before passing it to the next step. By composing pipes in different ways, different
data access patterns can be created.

## Usage

Create a pipeline composed of a set of pipes:

```ruby
write_pipeline = StoragePipeline::Pipeline.new <<
   StoragePipeline::WritePipes::AttributeSerializer.new <<
   StoragePipeline::Pipes::FieldRename.new(:to => :to_emails, :from => :from_email) <<
   StoragePipeline::Pipes::ModKey.new <<
   StoragePipeline::WritePipes::CassandraWriter.new(:table_1, metadata_client) <<
   StoragePipeline::WritePipes::CassandraWriter.new(:table_2, indexes_client) <<
   StoragePipeline::WritePipes::CassandraWriter.new(:table_3, indexes_client)
```

Then, push data down the pipe:

```ruby
result = write_pipeline.push(attributes)
```

View the value of the set of successive transformations performed by the pipe:
```ruby
result.value
```

A pipeline performs a bunch of sequential transformations to the data being passed down the pipe. It may also have side
effects, such as storing data. The specific pipes provided in this library aim are aimed at two uses: writing and
reading data.

A write pipeline takes an initial set of attributes, performing a set of transfomations such as serialization and so on,
before storing the data in one or more storage outputs. For example, this gem provides storage pipes for Cassandra and
Amazon S3, but it is easy to write a pipe for other storage backends.

Conversely, a read pipeline takes initially a set of options. These options be transformed by the pipeline, and then used
to read data from an external source. This data may then be transformed by the pipeline - for example, performing
deserialization or data mapping operations.

```ruby
read_pipeline = StoragePipeline::Pipeline.new <<
   StoragePipeline::ReadPipes::PaginationDecoding.new <<
   StoragePipeline::ReadPipes::CassandraItems.new(:table, indexes_client) <<
   StoragePipeline::Pipes::FieldRename.new(:to_emails => :to, :from_email => :from) <<
   StoragePipeline::ReadPipes::PaginationEncoding.new <<
   StoragePipeline::ReadPipes::VirtusDeserializer.new(message_attributes) <<
   StoragePipeline::ReadPipes::VirtusParser.new(MyModelClass)

result = read_pipeline.push(:row => '1', :id => 'i', :page_token => 'sdf')
result.value # Enumerator with matching instances of MyModelClass
```

Note that pipe order matters. In the example read pipe above, `PaginationDecoding` decodes pagination options, thus
performing an operation on the initial options provided. The `CassandraItems` pipe uses the options to retrieve items from
Cassandra, and subsequent elements of the pipeline are designed to transform this retrieved data. Thus, it would not be
sensible for the `PaginationDecoding` pipe to come after the `CassandraItems` pipe.

### Creating and using pipelines

A pipeline is an instance of `StoragePipeline::Pipeline`, to which pipes are appended using the `<<` operator.

```ruby
my_pipeline = StoragePipeline::Pipeline.new <<
   StoragePipeline::ReadPipes::PaginationDecoding.new <<
   StoragePipeline::ReadPipes::CassandraItems.new(:table, indexes_client)
   StoragePipeline::ReadPipes::PaginationEncoding.new
```

To invoke the pipeline, use the `push` method and provide the data to enter the pipeline:

```ruby
pipe_status = my_pipeline.push(:row => '1', :id => 'i')
```

Here, `pipe_status` is a `StoragePipeline::PipeStatus` object, which contains two attributes, `pipe_status.value` and
`pipe_status.status`. The value is the returned result of the series of tranformations applied by the pipeline. The status
contains metadata about the push operation that might be created by each pipe in the pipeline.

### Creating new pipes

A pipe must implement the pipe method, which takes two arguments: the object entering the pipe, as well as the status. It
should return the object leaving the pipe:

```ruby
class MyPipe
  def pipe(attributes, status)
    attributes[:c] = attributes[:a] + attributes[:b]
    status[:processed_by_my_pipe] = true
    attributes
  end
end
```

This example pipe modifies `attributes` before returning it. It also sets a flag on the status object.

Generally, pipes in a write pipeline operate on an attributes hash (containing the attributes meant to be written to a data
store). Pipes in a read pipeline initially might modify arguments. A data retrieval pipe would then use the arguments to
fetch data, and subsequent pipes would perform operations on the enumeration of data items. Thus, a read pipe might look
something like:

```ruby
class Deserialize
  def pipe(items, status)
     items.map { |item| deserialize(item) }
  end

  def deserialize(item)
    ...
  end
end
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
