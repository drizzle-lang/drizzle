require "./expression"
require "../token"

module Drizzle
  module AST
    # Node class for handling list literals
    class ListLiteral < Expression
      @token : Token
      @elements : Array(Expression)

      def initialize(@token : Token, @elements : Array(Expression))
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        elements = [] of String
        @elements.each do |element|
          elements << element.to_s
        end

        return "[#{elements.join ", "}]"
      end

      # The token that caused the creation of this node instance
      getter token

      # The array of elements in the list
      getter elements
    end
  end
end
