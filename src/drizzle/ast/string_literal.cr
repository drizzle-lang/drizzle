require "./expression"
require "../token"

module Drizzle
  module AST
    # Node class representing an String.
    class StringLiteral < Expression
      @token : Token
      @value : String

      def initialize(@token, @value)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "'#{@token.literal}'"
      end

      # The token that caused the generation of this node
      getter token
      # The value of the string
      getter value
    end
  end
end
