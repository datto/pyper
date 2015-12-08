module Pyper::Pipes; end

require_relative 'pipes/read'
require_relative 'pipes/write'

# require the individual generic pipes
require_relative 'pipes/mod_key'
require_relative 'pipes/field_rename'
require_relative 'pipes/default_values'
require_relative 'pipes/no_op'
require_relative 'pipes/remove_fields'
