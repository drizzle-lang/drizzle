require "./hashable"

module Drizzle
  module Object
    class StringObj < Hashable
      @value : String

      def initialize(@value)
        @object_type = ObjectType::STRING
        @hash = generate_hash
      end

      def inspect : String
        return "#{@value}"
      end

      private def generate_hash : DictKey
        # To save me from having to include a lib I'm just gonna write the method here
        # using https://github.com/pawandubey/crystal_fnv/blob/master/src/crystal_fnv.cr for basis
        hash = 0xcbf29ce484222325
        prime = 1099511628211
        mask = 18446744073709551615
        @value.each_byte do |byte|
          hash ^= byte
          hash *= prime
          hash &= mask
        end
        return DictKey.new @object_type, hash
      end

      getter value
    end
  end
end
