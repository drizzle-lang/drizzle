module Sapphire
  # The character that is used in situations such as the EOF or ILLEGAL Tokens
  NULL_CHARACTER = "\0"

  # The Lexer is the class in charge of reading in input from a file and converting the text into tokens.
  #
  # It works similarly to a Python generator, with the `#get_next_token` method generating the next token from the source file.
  class Lexer
    @file_name : String
    @lines : Array(String)
    @line_num : Int32 = 0
    @char_num : Int32 = 0
    @read_char_num : Int32 = 0
    @current_line : String = ""
    @current_char : String = NULL_CHARACTER

    # Create a Lexer instance using a String.
    # This string will be split on newline characters and turned into an array of lines, as if it had come from a File.
    #
    # Since this should only be called from the REPL, the file_name will be "<stdin>".
    def initialize(input : String)
      @file_name = "<stdin>"
      @lines = input.split "\n"
    end
  end
end
