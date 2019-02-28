require "./types"
require "./hash_key"

module Drizzle
  # Module containing the internal representations of data types within Drizzle
  module Object
    # Base class for objects
    abstract class Object
      @object_type : ObjectType

      def initialize
        @object_type = ObjectType::OBJECT
      end

      def hash : DictKey?
        return nil
      end

      # A method that converts the object into a string representation, typically involving the value of the object
      abstract def inspect : String

      # A String representing the type of the object
      getter object_type
    end
  end
end
