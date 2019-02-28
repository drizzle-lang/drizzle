require "./expression"
require "./identifier"
require "../token"

module Drizzle
  module AST
    # Node class for handling iterable index expressions
    class IndexExpression < Expression
      @token : Token
      @left : Expression
      @index : Expression

      def initialize(@token : Token, @left : Expression, @index : Expression)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "(#{@left.to_s}[#{@index.to_s}])"
      end

      # The token that caused the creation of this node instance
      getter token

      # The expression representing the iterable being indexed
      getter left

      # The index of the iterable to be returned
      getter index
    end
  end
end
