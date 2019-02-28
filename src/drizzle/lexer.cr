require "./token"

module Drizzle
  # The Lexer is the class in charge of reading in input from a file and converting the text into tokens.
  #
  # It works similarly to a Python generator, with the `#get_next_token` method generating the next token from the source file.
  class Lexer
    @file_name : String = "<stdin>"
    @lines : Array(String) = [] of String
    @line_num : Int32 = 0
    @char_num : Int32 = 0
    @read_char_num : Int32 = 0
    @current_line : String = ""
    @current_char : Char = Char::ZERO

    # Create a Lexer instance using a String.
    # This string will be split on newline characters and turned into an array of lines, as if it had come from a File.
    #
    # Since this should only be called from the REPL, the file_name will be "<stdin>".
    def initialize(input : String)
      @lines = input.split "\n"
      # Set the initial current line if there is any line in the input to set it to.
      @current_line = @lines[0] unless @lines.size == 0
      # Initialize all the pointers correctly by using the new `read_next_char` method.
      self.read_next_char
    end

    # Create a Lexer instance using a File instance.
    #
    # This will replace the filename and load the lines in to use as input.
    def initialize(file : File)
      # Remove the current directory from the path name
      @file_name = file.path.split(Dir.current)[-1]
      # Set the lines and current line values
      @lines = File.read_lines file.path
      @current_line = @lines[0] unless @lines.size == 0
      # Initialize all character pointers
      self.read_next_char
    end

    # Update the `char_num` and `read_char_num` pointers, as well as the `current_line` and `current_char` values.
    # If the end of the current line has been reached, move to the next line (if exists).
    # If the end of the input has been reached, set the current char to be the `Char::ZERO`.
    def read_next_char
      # Firstly, check if we have reached the end of the current line or not.
      if @read_char_num >= @current_line.size
        # Move to the start of the next line
        @line_num += 1
        @char_num = 0
        @read_char_num = 0

        # Now check to see if we have gone past the last line in the file or not
        if @line_num > @lines.size
          # If so, set both the current line and character values to be the Char::ZERO.
          # The line is set to this as making it empty will cause `skip_whitespace` to loop infinitely.
          @current_line = Char::ZERO.to_s
          @current_char = Char::ZERO
        elsif @line_num == @lines.size
          @current_line = ""
          @current_char = '\n'
        else
          # If not, update the current line and character values to be the actual current line and the newline character.
          @current_line = @lines[@line_num]
          @current_char = '\n'
        end
      else
        # If not, just update all the character pointers to be the next character.
        @current_char = @current_line[@read_char_num]
        @char_num = @read_char_num
        @read_char_num += 1
      end
    end

    # Check what the next character on the current line is, without updating all the pointers
    def peek_next_char : Char
      if @read_char_num >= @current_line.size
        return Char::ZERO
      else
        return @current_line[@read_char_num]
      end
    end

    # Generate the next Token instance from the given input.
    #
    # This method first tries the current_char of the Lexer against all of the single character Tokens in Drizzle.
    # If it does not match, it then attempts to build up identifiers / keywords or numbers, depending on what the character is.
    def get_next_token : Token
      # Skip whitespace characters
      self.skip_whitespace
      # Skip comments by proceeding to the end of the line
      if @current_char == '#'
        # At a later point we might tokenize comments and use them for something, either in the interpreter or at least in the docs generator
        self.skip_comment
      end
      # Save the current values of the line and character numbers to use them in the initialization of the Token instance.
      # These values have 1 added to them as they should be 1-indexed when output in error messages
      current_line = @line_num + 1
      current_char = @char_num + 1
      token_type : TokenType
      literal : String
      no_read = false # If this is false, read the next character after the `case` statement
      # Attempt to generate a Token instance based off of the @current_char value
      case @current_char
      when '\n'
        token_type = TokenType::EOL
        literal = "\n"
        # Because of weirdness that I currently can't solve, manually set line / char nums for EOL tokens
        current_line -= 1
        current_char = @lines[current_line - 1].size + 1
      when '"', '\''
        # strings
        token_type = TokenType::STRING
        val = read_string @current_char
        # Check to make sure we have a valid string
        if val.nil?
          token_type = TokenType::ILLEGAL
          literal = Char::ZERO.to_s
        else
          literal = val
        end
      when '='
        if self.peek_next_char == '='
          token_type = TokenType::EQ
          literal = "=="
          # Read the second '=' char
          self.read_next_char
        else
          token_type = TokenType::ASSIGN
          literal = "="
        end
      when '+'
        token_type = TokenType::PLUS
        literal = "+"
      when '-'
        # Check if it's creating a minus operator or a return_type operator
        if self.peek_next_char == '>'
          token_type = TokenType::RETURN_TYPE
          literal = "->"
          # Read the '>' character
          self.read_next_char
        else
          token_type = TokenType::MINUS
          literal = "-"
        end
      when '*'
        token_type = TokenType::ASTERISK
        literal = "*"
      when '/'
        token_type = TokenType::SLASH
        literal = "/"
      when '<'
        if self.peek_next_char == '='
          token_type = TokenType::LT_EQ
          literal = "<="
          # Read the '=' character
          self.read_next_char
        else
          token_type = TokenType::LT
          literal = "<"
        end
      when '>'
        if self.peek_next_char == '='
          token_type = TokenType::GT_EQ
          literal = ">="
          # Read the '=' char
          self.read_next_char
        else
          token_type = TokenType::GT
          literal = ">"
        end
      when ','
        token_type = TokenType::COMMA
        literal = ","
      when ':'
        token_type = TokenType::COLON
        literal = ":"
      when '('
        token_type = TokenType::LEFT_PAREN
        literal = "("
      when ')'
        token_type = TokenType::RIGHT_PAREN
        literal = ")"
      when '{'
        token_type = TokenType::LEFT_BRACE
        literal = "{"
      when '}'
        token_type = TokenType::RIGHT_BRACE
        literal = "}"
      when '['
        token_type = TokenType::LEFT_BRACKET
        literal = "["
      when ']'
        token_type = TokenType::RIGHT_BRACKET
        literal = "]"
      when '!'
        if self.peek_next_char == '='
          token_type = TokenType::NOT_EQ
          literal = "!="
          # Read the '=' character
          self.read_next_char
        else
          # Bang on its own is currently an Illegal token
          token_type = TokenType::ILLEGAL
          literal = Char::ZERO.to_s
        end
      when Char::ZERO
        token_type = TokenType::EOF
        literal = Char::ZERO.to_s
        # Also because of weirdness, EOF tokens are put 2 lines after where they are meant to be
        current_line -= 1
      else
        # There are some checks to be made here, as this could possibly be a keyword, identifier or number
        if @current_char.letter?
          literal = self.read_identifier
          token_type = Drizzle::Keywords.fetch literal, TokenType::IDENTIFIER
          no_read = true
        elsif @current_char.number?
          literal = self.read_number
          token_type = TokenType::INTEGER
          no_read = true
        else
          token_type = TokenType::ILLEGAL
          literal = Char::ZERO.to_s
        end
      end
      # Update the positions of the characters if necessary
      self.read_next_char unless no_read
      # Generate and return the Token instance
      return Token.new token_type, literal, @file_name, current_line, current_char
    end

    # Builds up a possible identifier from the source.
    #
    # This method is run whenever `#get_next_token` comes across a letter in the input.
    def read_identifier : String
      # Save the current position and the current line, as well as the position of the end of the identifier
      start_pos = @char_num
      line_num = @line_num
      end_pos = @char_num
      # Loop until current character is not a possible identifier character, or we have moved onto the next line
      while line_num == @line_num && self.valid_identifier_char? @current_char
        self.read_next_char
        end_pos += 1
      end
      # Return the characters in `line` from `start_pos` to `end_pos`
      return @lines[line_num][start_pos...end_pos]
    end

    # Builds up an integer number from the source code.
    #
    # The interpreter book only handles integer numbers when I move to creating an ANTLR parser then Drizzle will have other number types too :D
    # The number is returned as a String still, to keep Token implementation simple
    def read_number : String
      # Save the current position and the current line, as well as the position of the end of the identifier
      start_pos = @char_num
      line_num = @line_num
      end_pos = @char_num
      # Loop until current character is not a possible identifier character, or we have moved onto the next line
      while line_num == @line_num && @current_char.number?
        self.read_next_char
        end_pos += 1
      end
      # Return the characters in `line` from `start_pos` to `end_pos`
      return @lines[line_num][start_pos...end_pos]
    end

    # Builds up a string from the source code
    #
    # Takes in the character that was used to open the string, to ensure we close the string with the same character
    def read_string(opener : Char) : String?
      # move on to the first character of the string before doing anything
      self.read_next_char
      start_pos = @char_num
      while @current_char != opener
        # Check for new lines in the string, they are not allowed currently
        if @current_char == '\n'
          return nil
        end
        self.read_next_char
      end
      return @lines[@line_num][start_pos...@char_num]
    end

    # Skip whitespace characters in the input as it is unnecessary to turn them into Tokens for Drizzle
    #
    # Whitespace characters include spaces, newlines, tabs, carriage returns, etc.
    def skip_whitespace
      whitespace_chars = [' ', '\r', '\t']
      while whitespace_chars.includes? @current_char
        self.read_next_char
      end
    end

    # Once a comment is found in the source, skip the lexer to the next line.
    #
    # In Drizzle, there are currently only single line comments, so we can just skip the line.
    def skip_comment
      # The easiest way is to set the read_pos to be the end of the current line and then call read next char
      @read_char_num = @current_line.size
      self.read_next_char
      # Make sure to skip whitespace again to be safe
      self.skip_whitespace
    end

    # Determine whether a given character is allowed to be used as part of an identifier name.
    #
    # Since the `#read_identifier` method is only run when the `#get_next_token` finds a letter, we can safely allow numbers in this as well.
    def valid_identifier_char?(char : Char) : Bool
      extra_chars = ['?', '!', '_']
      return char.alphanumeric? || extra_chars.includes? char
    end
  end
end
