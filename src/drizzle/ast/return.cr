require "./expression"
require "./statement"
require "../token"

module Drizzle
  module AST
    # Node class for representing a `return` statement
    # `return <expression>`
    class Return < Statement
      @token : Token
      @value : Expression

      def initialize(@token, @value)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "#{self.literal} #{@value.to_s}"
      end

      # The token that caused the generation of this node
      getter token
      # The expression that will be evaluated to return a result
      getter value
    end
  end
end
