require "./node"
require "./statement"

module Drizzle
  module AST
    class Program < Node
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
