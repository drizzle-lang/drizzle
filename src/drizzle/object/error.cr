require "./object"

module Drizzle
  module Object
    ERROR_TYPE = "ERROR"

    class Error < Object
      @message : String

      def initialize(@message)
        @object_type = ERROR_TYPE
      end

      def inspect : String
        return "ERROR: #{@message}"
      end

      getter message
    end
  end
end
