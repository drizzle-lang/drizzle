require "./expression"
require "./statement"
require "../token"

module Drizzle
  module AST
    # Node representing an expression statement, which is a single expression on its own line
    # <expression>
    class ExpressionStatement < Statement
      @token : Token
      @expression : Expression?

      def initialize(@token, @expression)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return @expression.to_s
      end

      # The token that caused the generation of this node
      getter token
      # The expression that makes up the node
      getter expression
    end
  end
end
