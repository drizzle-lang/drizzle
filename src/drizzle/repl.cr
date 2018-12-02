module Drizzle
  # Class for handling the Read-Eval-Print-Loop (REPL) environment for Drizzle.
  #
  # Currently, since we can't exactly 'Eval' yet, the REPL environment simply lexes and prints out the tokens that were created.
  class REPL
    @@prompt = ">>> "

    # Start the REPL environment.
    #
    # REPL ends on an empty input.
    def initialize
      running = true
      while running
        print @@prompt
        input = gets(chomp: true)
        if !input || input == ""
          puts "Goodbye!"
          running = false
          next
        end

        puts "Input: '#{input}'"

        # Initialize a Lexer, lex the input and print out the Tokens
        lexer = Lexer.new input
        parser = Parser.new lexer
        program = parser.parse_program
        if parser.errors.size != 0
          self.print_parser_errors parser
          next
        end
        puts program.to_s
      end
    end

    # Print parser errors in a nice format
    def print_parser_errors(parser : Parser)
      parser.errors.each do |error|
        puts error
      end
    end
  end
end
