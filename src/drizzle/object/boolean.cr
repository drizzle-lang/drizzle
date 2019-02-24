require "./object"

module Drizzle
  module Object
    BOOLEAN_TYPE = "BOOLEAN"

    class Boolean < Object
      @value : Bool

      def initialize(@value)
        @object_type = BOOLEAN_TYPE
      end

      def inspect : String
        return "#{@value}"
      end

      getter value
    end
  end
end
