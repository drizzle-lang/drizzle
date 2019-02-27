require "./block"
require "./identifier"
require "./statement"
require "./typed_identifier"
require "../token"

module Drizzle
  module AST
    # Node representing a function definition. Functions are first-class in Drizzle, meaning that function names can be used as normal expressions.
    #
    # The difference between what Drizzle does and what Monkey does is that in Monkey, the function literals themselves are expressions, whereas in Drizzle they are statements.
    class Function < Statement
      @token : Token
      @name : Identifier
      @params : Array(TypedIdentifier)
      @ret_type : Identifier?
      @body : BlockStatement

      def initialize(@token : Token, @name : Identifier, @params : Array(TypedIdentifier), @ret_type : Identifier?, @body : BlockStatement)
      end

      def literal : String
        return @token.literal
      end

      def to_s : String
        param_strings = [] of String
        @params.each do |param|
          param_strings << param.to_s
        end
        builder = String::Builder.new
        builder << "#{@token.literal} #{@name.to_s} (#{param_strings.join ", "})"
        if !@ret_type.nil?
          builder << " -> #{@ret_type.to_s}"
        end
        builder << " {\n#{@body.to_s}\n}"
        return builder.to_s
      end

      # The token that led to the creation of the node
      getter token

      # The Identifier node representing the name of the function
      getter name

      # An array of TypedIdentifiers representing parameters to the function
      getter params

      # The return type of the function
      getter ret_type

      # The block making up the body of the function
      getter body
    end
  end
end
