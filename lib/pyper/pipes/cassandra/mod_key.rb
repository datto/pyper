module Pyper::Pipes::Cassandra
  # Adds the :mod_key field to the output attributes, which is based on the hash of
  # a particular field in the input attributes.
  # @example
  # If the pipe is configured with an id field of :id, then the input
  #   { id: 'abc' }
  # would result in an output of
  #   { id: 'abc', mod_key: 22 }
  # Here the value 22 is within the range [0,mod_size - 1] and is uniquely
  # determined by id.
  class ModKey
    attr_reader :mod_size, :id_field

    # @param mod_size [Integer] mod keys will fall within the range [0,mod_key - 1]
    # @param id_field [Symbol] the attribute to use when generating the mod key.
    def initialize(mod_size = 100, id_field = :id)
      @mod_size = mod_size
      @id_field = id_field
    end

    # @param attributes [Hash] An attribute hash
    # @param status [Hash] The mutable status field
    # @return [Hash] The attribute hash with the mod_key field added
    def pipe(attributes, status)
      attributes.merge!(:mod_key => mod(attributes[id_field]))
    end

    def mod(value)
      Zlib::crc32(value) % mod_size
    end
  end
end
