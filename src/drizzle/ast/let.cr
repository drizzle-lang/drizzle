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
      @value : Expression

      def initialize(@token, @name, @datatype, @value)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        return "#{self.literal} #{@name.to_s}: #{@datatype.to_s} = #{@value.to_s}"
      end

      # The token that caused the generation of this node
      getter token
      # The name of the variable being assigned to
      getter name
      # The datatype of the variable being assigned to
      getter datatype
      # The expression that will generate a value to assign to the variable
      getter value
    end
  end
end
