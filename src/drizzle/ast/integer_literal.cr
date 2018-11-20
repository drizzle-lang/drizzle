require "./expression"
require "../token"

module Drizzle
  module AST
    # Node class representing an Integer.
    class IntegerLiteral < Expression
      @token : Token
      @value : Int64?

      def initialize(@token, @value)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return @token.literal
      end

      # The token that caused the generation of this node
      getter token
      # The value of the integer
      getter value
    end
  end
end
