require "./statement"

module Drizzle
  module AST
    # A Program Node is the root of the entire program, and contains an array of statements.
    class Program < Statement
      @statements : Array(Statement)

      def initialize(@statements : Array(Statement))
      end

      def literal : String
        unless @statements.empty?
          return @statements[0].literal
        else
          return ""
        end
      end

      def to_s : String
        builder = String::Builder.new
        @statements.each do |stmnt|
          builder << "#{stmnt.to_s}\n"
        end
        return builder.to_s.chomp
      end

      # An array of statements that make up the program
      getter statements
    end
  end
end
