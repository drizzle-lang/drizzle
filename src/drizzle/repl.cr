module Drizzle
  # Class for handling the Read-Eval-Print-Loop (REPL) environment for Drizzle.
  #
  # I'm finally able to add Evaluation to the REPL environment
  class REPL
    @@prompt = ">>> "

    # Start the REPL environment.
    #
    # REPL ends on an empty input.
    def initialize
      running = true
      # Create a single environment here to maintain state
      env = Environment.new
      while running
        print @@prompt
        input = gets(chomp: true)
        if !input || input == ""
          puts "Goodbye!"
          running = false
          next
        end

        # Initialize a Lexer, lex the input and print out the Tokens
        lexer = Lexer.new input
        parser = Parser.new lexer
        program = parser.parse_program
        if parser.errors.size != 0
          self.print_parser_errors parser
          next
        end
        evaluated = Evaluator.eval program, env
        puts evaluated.inspect
      end
    end

    # Print parser errors in a nice format
    def print_parser_errors(parser : Parser)
      parser.errors.each do |error|
        puts error.colorize(:red)
      end
    end
  end
end
