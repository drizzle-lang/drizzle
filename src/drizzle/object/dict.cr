require "./object"

module Drizzle
  module Object
    # Class to use as the value in Drizzle dicts that also maintain the key that was used to insert them
    class DictPair
      @key : Drizzle::Object::Object
      @value : Drizzle::Object::Object

      def initialize(@key, @value)
      end

      getter key
      getter value
    end

    # Class representing a dictionary (also called a hashmap)
    class Dict < Object
      @pairs : Hash(DictKey, DictPair)

      def initialize(@pairs)
        @object_type = ObjectType::DICT
      end

      def inspect : String
        pairs = [] of String
        @pairs.each do |_, pair|
          pairs << "#{pair.key.inspect}: #{pair.value.inspect}"
        end
        return "{#{pairs.join ", "}}"
      end

      getter pairs
    end
  end
end
