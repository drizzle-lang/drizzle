require "./object"
require "./dict_key"

module Drizzle
  # Module containing the internal representations of data types within Drizzle
  module Object
    # Base class for hashable objects
    abstract class Hashable < Object
      @hash : DictKey

      def initialize
        @object_type = ObjectType::OBJECT
        @hash = generate_hash
      end

      abstract def generate_hash : DictKey

      # The hashed form of the object
      getter hash
    end
  end
end
