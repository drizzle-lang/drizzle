require "./object"
require "../ast/block"
require "../ast/typed_identifier"
require "../environment"

module Drizzle
  module Object
    class Function < Object
      # Block of the function
      @body : AST::BlockStatement
      # Scope of the function
      @env : Environment
      # Name of the function (for inspection)
      @name : AST::Identifier
      # Parameters of the function
      @parameters : Array(AST::TypedIdentifier)
      # Return type of the function
      @return_type : AST::Identifier?

      def initialize(@name, @parameters, @return_type, @body, @env)
        @object_type = ObjectType::FUNCTION
      end

      def inspect : String
        param_strings = [] of String
        @parameters.each do |param|
          param_strings << param.to_s
        end
        builder = String::Builder.new
        builder << "function #{@name.to_s} (#{param_strings.join ", "})"
        if !@return_type.nil?
          builder << " -> #{@return_type.to_s}"
        end
        builder << " {\n#{@body.to_s}\n}"
        return builder.to_s
      end

      getter body
      getter env
      getter name
      getter parameters
      getter return_type
    end
  end
end
