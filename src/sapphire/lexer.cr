module Sapphire
  # The character that is used in situations such as the EOF or ILLEGAL Tokens
  NULL_CHARACTER = '\0'

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
    @current_char : Char = NULL_CHARACTER

    # Create a Lexer instance using a String.
    # This string will be split on newline characters and turned into an array of lines, as if it had come from a File.
    #
    # Since this should only be called from the REPL, the file_name will be "<stdin>".
    def initialize(input : String)
      @file_name = "<stdin>"
      @lines = input.split "\n"
      # Initialize all the pointers correctly by using the new `read_next_char` method.
      self.read_next_char
    end

    # Update the `char_num` and `read_char_num` pointers, as well as the `current_line` and `current_char` values.
    # If the end of the current line has been reached, move to the next line (if exists).
    # If the end of the input has been reached, set the current char to be the `NULL_CHARACTER`.
    def read_next_char
      # Firstly, check if we have reached the end of the current line or not.
      if @read_char_num >= @current_line.size
        # Move to the start of the next line
        @line_num += 1
        @char_num = 0
        @read_char_num = 0

        # Now check to see if we have gone past the last line in the file or not
        if @line_num >= @lines.size
          # If so, set both the current line and character values to be the NULL_CHARACTER.
          # The line is set to this as making it empty will cause `skip_whitespace` to loop infinitely.
          @current_line = NULL_CHARACTER.to_s
          @current_char = NULL_CHARACTER
        else
          # If not, update the current line and character values to be the actual current line and the newline character.
          @current_line = @lines[@line_num - 1] # -1 because @line_num is 1-indexed for use in error messages.
          @current_char = '\n'
        end
      else
        # If not, just update all the character pointers to be the next character.
        @current_char = @current_line[@read_char_num]
        @char_num = @read_char_num
        @read_char_num += 1
      end
    end
  end
end
