require "./object"

module Drizzle
  module Object
    class Integer < Object
      @value : Int64

      def initialize(@value)
        @object_type = ObjectType::INTEGER
      end

      def inspect : String
        return "#{@value}"
      end

      getter value
    end
  end
end
