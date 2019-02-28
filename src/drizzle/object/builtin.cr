require "./object"

module Drizzle
  module Object
    class Builtin < Object
      @function : BuiltinFunction

      def initialize(@function)
        @object_type = ObjectType::BUILTIN
      end

      def inspect : String
        return "builtin function"
      end

      getter function
    end
  end
end
