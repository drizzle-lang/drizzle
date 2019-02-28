require "./object"

module Drizzle
  module Object
    class Boolean < Object
      @value : Bool

      def initialize(@value)
        @object_type = ObjectType::BOOLEAN
      end

      def inspect : String
        return "#{@value}"
      end

      getter value
    end
  end
end
