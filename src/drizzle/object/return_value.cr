require "./object"

module Drizzle
  module Object
    class ReturnValue < Object
      @value : Object

      def initialize(@value)
        @object_type = ObjectType::RETURN_VALUE
      end

      def inspect : String
        return @value.inspect
      end

      getter value
    end
  end
end
