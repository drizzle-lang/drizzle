require "./block"
require "./expression"
require "./statement"
require "../token"

module Drizzle
  module AST
    # Node representing an if statement.
    # `if (<condition>) <consequence> (elsif (<condition>) <consequence>)* (else <alternative>)?`
    class IfStatement < Statement
      @token : Token
      @condition : Expression
      @consequence : BlockStatement
      @alt_consequences : Array(IfStatement)
      @alternative : BlockStatement?

      def initialize(@token : Token, @condition : Expression, @consequence : BlockStatement, @alt_consequences : Array(IfStatement) = [] of IfStatement, @alternative : BlockStatement? = nil)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        builder = String::Builder.new
        builder << "if #{@condition.to_s} #{@consequence.to_s}"
        @alt_consequences.each do |alt|
          builder << " #{alt.to_s}"
        end
        if !@alternative.nil?
          builder << " #{@alternative.to_s}"
        end
        return builder.to_s
      end

      # The token that led to the creation of the statement node
      getter token

      # The initial condition to be tested
      getter condition

      # The set of statements to be run if the initial condition has proven to be true
      getter consequence

      # An optional array of alternative conditions and consequences to run in case the first condition fails
      getter alt_consequences

      # An optional alternative block to be run if all prior conditions have failed
      getter alternative
    end
  end
end
