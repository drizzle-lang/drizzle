require "./expression"
require "./identifier"
require "../token"

module Drizzle
  module AST
    # Node class for handling function call expressions
    class CallExpression < Expression
      @token : Token
      @function : Identifier
      @arguments : Array(Expression)

      def initialize(@token : Token, @function : Identifier, @arguments : Array(Expression))
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        args = [] of String
        @arguments.each do |arg|
          args << arg.to_s
        end

        return "#{@function.to_s}(#{args.join ", "})"
      end

      # The token that caused the creation of this node instance
      getter token

      # The identifier representing the function name to call
      getter function

      # The array of arguments to be passed into the function
      getter arguments
    end
  end
end
