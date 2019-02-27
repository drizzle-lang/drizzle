require "./object"

module Drizzle
  module Object
    RETURN_VALUE_TYPE = "RETURN_VALUE"

    class ReturnValue < Object
      @value : Object

      def initialize(@value)
        @object_type = RETURN_VALUE_TYPE
      end

      def inspect : String
        return @value.inspect
      end

      getter value
    end
  end
end
