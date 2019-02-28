require "./object"

module Drizzle
  module Object
    class List < Object
      @elements : Array(Object)

      def initialize(@elements)
        @object_type = ObjectType::LIST
      end

      def inspect : String
        elements = [] of String
        @elements.each do |element|
          elements << element.inspect
        end
        return "[#{elements.join ", "}]"
      end

      getter elements
    end
  end
end
