require "./expression"
require "../token"

module Drizzle
  module AST
    # Node class representing a Prefix Expression, such as unary `-`, or `not`
    class PrefixExpression < Expression
      @token : Token
      @operator : String
      @right : Expression?

      def initialize(@token, @operator, @right)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "(#{@operator}#{@right.to_s})"
      end

      # The token that caused the generation of this node
      getter token
      # The prefix operator (not, -)
      getter operator
      # The expression that is bound by the prefix operator
      getter right
    end
  end
end
