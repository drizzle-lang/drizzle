require "./hashable"

module Drizzle
  module Object
    class Boolean < Hashable
      @value : Bool

      def initialize(@value)
        @object_type = ObjectType::BOOLEAN
        @hash = generate_hash
      end

      def inspect : String
        return "#{@value}"
      end

      private def generate_hash : DictKey
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
