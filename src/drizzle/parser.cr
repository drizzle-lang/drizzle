require "./ast/*"
require "./lexer"
require "./token"

# Macroes

# Register a prefix parser for a given token and method name
macro add_prefix(token_type, method_name)
  self.register_prefix TokenType::{{token_type}}, ->{ self.{{method_name}}.as(AST::Expression) }
end

module Drizzle
  # # Type alias for Proc objects used in prefix notation parsing
  # alias PrefixParser = Proc(AST::Expression)
  # # Type alias for Proc objects used in infix notation parsing
  # alias InfixParser = Proc(AST::Expression, AST::Expression)

  # Enum representing the precedence order of operators in Drizzle.
  # Lower precedence operators will have a lower integer value, allowing for easy comparisons between precedences.
  enum Precedence
    # Default
    LOWEST
    # ==
    EQUALS
    # > or <
    LESSGREATER
    # +
    SUM
    # *
    PRODUCT
    # -x
    PREFIX
    # func(x)
    CALL
  end

  # A Parser reads in the tokens generated by a `Lexer` and constructs an Abstract Syntax Tree (AST) built from what it finds.
  class Parser
    @lexer : Lexer
    @current : Token
    @peek : Token
    @errors : Array(String)
    @prefix_parsers : Hash(TokenType, Proc(AST::Expression))
    @infix_parsers : Hash(TokenType, Proc(AST::Expression, AST::Expression))

    def initialize(@lexer : Lexer)
      # Read the first two tokens to set up curr and peek variables
      @current = @lexer.get_next_token
      @peek = @lexer.get_next_token
      @errors = [] of String
      @prefix_parsers = {} of TokenType => Proc(AST::Expression)
      @infix_parsers = {} of TokenType => Proc(AST::Expression, AST::Expression)
      # Set up known parser procs
      self.initialise_parsers
    end

    # Initialize parser methods for the parser to use when parsing expressions
    def initialise_parsers
      # Prefix Parsers
      add_prefix IDENTIFIER, parse_identifier
      add_prefix INTEGER, parse_integer_literal
      add_prefix NOT, parse_prefix_expression
      add_prefix MINUS, parse_prefix_expression

      # Infix Parsers
    end

    # Register a TokenType with a parser function that is run when the TokenType is discovered in a spot for prefix notation
    def register_prefix(token_type : TokenType, func : Proc(AST::Expression))
      @prefix_parsers[token_type] = func
    end

    # Register a TokenType with a parser function that is run when the TokenType is discovered in a spot for infix notation
    def register_infix(token_type : TokenType, func : Proc(AST::Expression, AST::Expression))
      @infix_parsers[token_type] = func
    end

    # Update the `@current` and `@peek` pointers contained in the Parser instance to the next token generated from the `Lexer`
    def next_token
      @current = @peek
      @peek = @lexer.get_next_token
    end

    # Parse a program and build a program node from it, and return it
    def parse_program : AST::Program
      statements = [] of AST::Statement
      while !@current.token_type.eof?
        statement = self.parse_statement
        if !statement.nil?
          statements << statement
        end
        self.next_token
      end
      return AST::Program.new statements
    end

    # Parse a statement found at `@current` and return it, or nil if no statement can be parsed
    def parse_statement : AST::Statement?
      case @current.token_type
      when TokenType::LET
        return self.parse_let_statement
      when TokenType::RETURN
        return self.parse_return_statement
      end
      # Work under the assumption that it could be an expression statement
      return self.parse_expression_statement
    end

    # Attempt to parse a `let` statement found at the current token, returning the node if possible, or nil if not
    def parse_let_statement : AST::Let?
      # Ensure that the token setup is how we need it to be for a let statement: let <ident>: <ident> = <exp>
      token = @current

      if !self.eat? TokenType::IDENTIFIER
        return nil
      end

      # Generate an Identifier node for the name
      name = AST::Identifier.new @current, @current.literal

      # Expect a colon token next
      if !self.eat? TokenType::COLON
        return nil
      end
      # The COLON token is ignored when building a let statement node but it has to be there

      # Expect another identifier here
      if !self.eat? TokenType::IDENTIFIER
        return nil
      end

      # Generate an Identifier node for the type
      datatype = AST::Identifier.new @current, @current.literal

      # For now we will skip the expression part (skip to the next let token)
      while !@peek.token_type.let?
        if @current.token_type.eof?
          break
        end
        self.next_token
      end
      # TODO - Implement the parsing of expressions
      expression = nil

      return AST::Let.new token, name, datatype, expression
    end

    # Attempt to parse a `return` statement found at the current token, returning the node if possible, or nil if not
    def parse_return_statement : AST::Return?
      token = @current

      # Get the next token
      self.next_token

      # TODO - Parse expressions properly
      while !@peek.token_type.return?
        if @current.token_type.eof?
          break
        end
        self.next_token
      end
      expression = nil

      # Create and return the node
      return AST::Return.new token, expression
    end

    # Attempt to parse an expression statement found at the current token, returning the node if possible, or nil if not
    def parse_expression_statement : AST::ExpressionStatement?
      token = @current
      expression = self.parse_expression Precedence::LOWEST
      return AST::ExpressionStatement.new token, expression
    end

    # Attempt to parse an expression.
    # This method is given a current precedence to compare against when necessary.
    def parse_expression(precedence : Precedence) : AST::Expression?
      # For now, we're only checking prefix expressions
      prefix_parser = @prefix_parsers.fetch @current.token_type, nil
      if prefix_parser.nil?
        @errors << "SyntaxError: No prefix parser function found for #{@current.token_type}\n\t#{@current.file_name} at line #{@current.line_num}, char #{@current.char_num}"
        return nil
      end
      prefix_parser = prefix_parser.not_nil!
      left_exp = prefix_parser.call
      return left_exp
    end

    # Expression parser methods

    # Parse an identifier found at the current token
    # `<identifier>`
    def parse_identifier : AST::Expression
      return AST::Identifier.new @current, @current.literal
    end

    # Attempt to parse an integer literal found at the current token, returning an Integer node with nil value if it can't.
    # This is to keep the typing in the parser code easier but I might change this later.
    # `<integer>`
    def parse_integer_literal : AST::Expression
      token = @current
      # Attempt to convert the current token string to an integer
      int = @current.literal.to_i64 { nil }
      if int.nil?
        @errors << "SyntaxError: Could not parse #{@current.literal} as an integer\n\t#{@current.file_name} at line #{@current.line_num}, char #{@current.char_num}"
        return AST::IntegerLiteral.new token, nil
      else
        return AST::IntegerLiteral.new token, int
      end
    end

    # Parse a prefix expression found at the current token
    # `<operator> <expression>`
    def parse_prefix_expression : AST::Expression
      token = @current
      operator = @current.literal
      self.next_token
      right = self.parse_expression Precedence::PREFIX
      return AST::PrefixExpression.new token, operator, right
    end

    # "Eat" the `@peek` token if the expected type matches the type of `@peek`
    #
    # Eating a token involves passing in the type of token that `@peek` is expected to be.
    # If it is the expected type, this method will advance the parser to the next token
    def eat?(expected_type : TokenType) : Bool
      if @peek.token_type == expected_type
        self.next_token
        return true
      else
        self.eat_error expected_type
        return false
      end
    end

    # Error functions

    # Add an error when `#eat?` gets an incorrect token type
    def eat_error(expected_type : TokenType)
      @errors << "SyntaxError: Expected #{expected_type}, got #{@peek.token_type}\n\t#{@peek.file_name} at line #{@peek.line_num}, char #{@peek.char_num}"
    end

    # Getters

    # The token that is currently being inspected by the parser
    getter current

    # A pointer to the next token coming up in the stream.
    # This is used to help guide what kind of node will be built from `@current`
    getter peek

    # Maintain an array of errors that are generated during the parsing step
    getter errors
  end
end
