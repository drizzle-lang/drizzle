require "./object"

module Drizzle
  module Object
    class Error < Object
      @message : String

      def initialize(@message)
        @object_type = ObjectType::ERROR
      end

      def inspect : String
        return "ERROR: #{@message}"
      end

      getter message
    end
  end
end
