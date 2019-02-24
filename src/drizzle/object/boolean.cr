require "./object"

module Drizzle
  module Object
    class Boolean < Object
      @value : Boolean

      def initialize(@value)
        @object_type = "Boolean"
      end

      def inspect : String
        return "#{@value}"
      end

      getter value
    end
  end
end
