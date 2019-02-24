module Drizzle
  # Module containing the internal representations of data types within Drizzle
  module Object
    alias ObjectType = String

    # Base class for objects
    abstract class Object
      @object_type : ObjectType

      def initialize
        @object_type = "OBJECT"
      end

      # A method that converts the object into a string representation, typically involving the value of the object
      abstract def inspect : String

      # A String representing the type of the object
      getter object_type
    end
  end
end
