require "./object"

module Drizzle
  module Object
    class Null < Object
      def initialize
        @object_type = ObjectType::NULL
      end

      def inspect : String
        return "null"
      end
    end
  end
end
