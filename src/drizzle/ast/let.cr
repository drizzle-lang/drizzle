require "./expression"
require "./identifier"
require "./statement"
require "../token"

module Drizzle
  module AST
    class Let < Statement
      @token : Token
      @name : Identifier
      @value : Expression

      def literal : String
        return @token.literal
      end
    end
  end
end
