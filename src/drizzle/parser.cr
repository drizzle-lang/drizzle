require "./ast/*"
require "./lexer"
require "./token"

module Drizzle
  class Parser
    @lexer : Lexer
    @current : Token | Nil = nil
    @peek : Token | Nil = nil

    def initialize(@lexer : Lexer)
      # Read the first two tokens to set up curr and peek variables
      self.next_token
      self.next_token
    end

    def next_token
      @current = @peek
      @peek = @lexer.get_next_token
    end

    def parse(node : AST::Program)
    end

    # Getters and setters (writing them myself because I know the tokens will never be nil)
    def current : Token
      return @current.not_nil!
    end

    def peek : Token
      return @peek.not_nil!
    end
  end
end
