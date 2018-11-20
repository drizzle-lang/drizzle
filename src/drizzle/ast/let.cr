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
      @datatype : Identifier
      # TODO - Remove the nilable from this once parsing expressions is added to the parser
      @value : Expression?

      def initialize(@token, @name, @datatype, @value)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "#{self.literal} #{@name.to_s}: #{@datatype.to_s} = #{@value.to_s}"
      end

      getter token
      getter name
      getter datatype
      getter value
    end
  end
end
