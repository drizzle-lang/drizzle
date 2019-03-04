require "./types"

module Drizzle
  # Module containing the internal representations of data types within Drizzle

  module Object
    # Class for storing hash keys for the upcoming dict implementations
    class DictKey
      @object_type : ObjectType
      @value : UInt64

      def initialize(@object_type, @value)
      end

      def ==(other : DictKey)
        return @object_type == other.object_type && @value == other.value
      end

      def hash
        # Return an integer that indicates this object
        # Would I be safe in just using the @value?
        @value
      end

      # The type of the object that created the hash key
      getter object_type

      # The hashed value of the object
      getter value
    end
  end
end
