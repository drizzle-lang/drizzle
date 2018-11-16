require "./expression"
require "./identifier"
require "./statement"
require "../token"

module Drizzle
  module AST
    # Node class representing a let statement.
    # `let <identifier>: <identifier> = <expression>``
    class Let < Statement
      @token : Token
      @name : Identifier
      @type : Identifier
      @value : Expression

      def literal : String
        return @token.literal
      end
    end
  end
end
