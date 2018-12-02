require "./statement"
require "../token"

module Drizzle
  module AST
    # Node defining a block. A block is a set of statements contained within braces.
    class BlockStatement < Statement
      @token : Token
      @statements : Array(Statements)

      def initialize(@token : Token, @statements : Array(Statement))
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        builder = String::Builder.new
        @statements.each do |stmnt|
          builder << stmnt.to_s
        end
        return builder.to_s
      end
    end
  end
end
