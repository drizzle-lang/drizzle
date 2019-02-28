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

      def hash : DictKey?
        return DictKey.new @object_type, @value.to_u64
      end

      getter value
    end
  end
end
