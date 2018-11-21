require "./expression"
require "../token"

module Drizzle
  module AST
    # Node class representing an Infix Expression, like '+', '-', '*', '/', '==', '!=', etc
    class InfixExpression < Expression
      @token : Token
      @left : Expression?
      @operator : String
      @right : Expression?

      def initialize(@token, @left, @operator, @right)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "(#{@left.to_s} #{@operator} #{@right.to_s})"
      end

      # The token that caused the generation of this node
      getter token
      # The expression found on the left side of the operator
      getter left
      # The prefix operator (not, -)
      getter operator
      # The expression found on the right side of the operator
      getter right
    end
  end
end
