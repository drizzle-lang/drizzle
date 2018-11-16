require "./expression"
require "../token"

module Drizzle
  module AST
    class Identifier < Expression
      @token : Token
      @value : String

      def literal : String
        return @token.String
      end
    end
  end
end
