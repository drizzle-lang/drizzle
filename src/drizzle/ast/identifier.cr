require "./expression"
require "../token"

module Drizzle
  module AST
    # Node class representing an Identifier.
    # An identifier is a name, be it for a function, variable, etc
    #
    # An Identifier is classed as an `Expression` because of situations such as `let x: int = y`.
    # In this case, `y` is an identifier (a variable) that returns a value.
    # We could have separate identifier tokens for left and right sides of an `=` symbol but that overcomplicates things a bit.
    class Identifier < Expression
      @token : Token
      @value : String

      def initialize(@token, @value)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return @value
      end

      getter token
      getter value
    end
  end
end
