require "./expression"
require "./statement"
require "../token"

module Drizzle
  module AST
    # Node class for representing a `return` statement
    # `return <expression>`
    class Return < Statement
      @token : Token
      # TODO - Remove nilable after expression parsing is added
      @value : Expression?

      def initialize(@token, @value)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "#{self.literal} #{@value.to_s}"
      end
    end
  end
end
