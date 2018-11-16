require "./statement"

module Drizzle
  module AST
    # A Program Node is the root of the entire program, and contains an array of statements.
    class Program < Statement
      @statements : [] of Statement

      def literal : String
        unless @statements.empty?
          return @statements[0].literal
        else
          return ""
        end
    end
  end
end
