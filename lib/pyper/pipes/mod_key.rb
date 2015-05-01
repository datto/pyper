module Pyper::Pipes
  class ModKey
    attr_reader :mod_size, :id_field
    def initialize(mod_size = 100, id_field = :id)
      @mod_size = mod_size
      @id_field = id_field
    end

    def pipe(attributes, status)
      attributes.merge!(:mod_key => mod(attributes[id_field]))
    end

    def mod(value)
      Zlib::crc32(value) % mod_size
    end
  end
end
