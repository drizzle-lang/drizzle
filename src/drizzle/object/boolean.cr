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

      def hash : DictKey?
        value : UInt64
        if @value
          value = 1_u64
        else
          value = 0_u64
        end
        return DictKey.new @object_type, value
      end

      getter value
    end
  end
end
