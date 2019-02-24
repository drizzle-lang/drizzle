require "./object"

module Drizzle
  module Object
    INTEGER_TYPE = "INTEGER"

    class Integer < Object
      @value : Int64

      def initialize(@value)
        @object_type = INTEGER_TYPE
      end

      def inspect : String
        return "#{@value}"
      end

      getter value
    end
  end
end
