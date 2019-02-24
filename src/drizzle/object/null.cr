require "./object"

module Drizzle
  module Object
    NULL_TYPE = "NULL"

    class Null < Object
      def initialize
        @object_type = NULL_TYPE
      end

      def inspect : String
        return "null"
      end
    end
  end
end
