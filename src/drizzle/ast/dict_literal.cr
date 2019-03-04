require "./expression"
require "../token"

module Drizzle
  module AST
    # Node class for handling dict literals
    class DictLiteral < Expression
      @token : Token
      @pairs : Hash(Expression, Expression)

      def initialize(@token : Token, @pairs : Hash(Expression, Expression))
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        pairs = [] of String
        @pairs.each do |k, v|
          pairs << "#{k.to_s}: #{v.to_s}"
        end

        return "{#{pairs.join ", "}}"
      end

      # The token that caused the creation of this node instance
      getter token

      # The hash of elements in the dictionary
      getter pairs
    end
  end
end
