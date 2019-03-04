require "./hashable"

module Drizzle
  module Object
    class Integer < Hashable
      @value : Int64

      def initialize(@value)
        @object_type = ObjectType::INTEGER
        @hash = generate_hash
      end

      def inspect : String
        return "#{@value}"
      end

      private def generate_hash : DictKey
        return DictKey.new @object_type, @value.to_u64
      end

      getter value
    end
  end
end
