require "./identifier"
require "../token"

module Drizzle
  module AST
    # Node class representing an Identifier with a data type.
    # `<name>: <type>`
    class TypedIdentifier < Identifier
      @datatype : Identifier

      def initialize(@token : Token, @value : String, @datatype : Identifier)
      end

      def to_s : String
        return "#{@value}: #{@datatype.to_s}"
      end

      # The type that has been given to this identifier. Currently only one typed variables are being handled, no union type handling yet.
      getter datatype
    end
  end
end
