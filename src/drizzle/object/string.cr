require "./object"

module Drizzle
  module Object
    class StringObj < Object
      @value : String

      def initialize(@value)
        @object_type = ObjectType::STRING
      end

      def inspect : String
        return "#{@value}"
      end

      getter value
    end
  end
end
