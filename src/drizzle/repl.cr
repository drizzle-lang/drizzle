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
        token : Token
        while !(token = lexer.get_next_token).token_type.eof?
          puts token.to_s
        end
      end
    end
  end
end
