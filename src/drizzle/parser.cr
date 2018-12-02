require "./ast/*"
require "./lexer"
require "./token"

# TODO: Clean up all the nil issues in the parser

# Macroes

# Register a prefix parser for a given token and method name
macro add_prefix(token_type, method_name)
  self.register_prefix TokenType::{{token_type}}, ->{ self.{{method_name}}.as(AST::Expression?) }
end

# Register an infix parser for a given token and method name
macro add_infix(token_type, method_name)
  self.register_infix TokenType::{{token_type}}, ->(exp : AST::Expression){ self.{{method_name}}(exp).as(AST::Expression) }
end

# Little bit of code cleanup regarding use of `self.eat?`
macro eat_or_return_nil(token_type)
  if !self.eat? TokenType::{{token_type}}
    return nil
  end
end

module Drizzle
  # # Type alias for Proc objects used in prefix notation parsing
  alias PrefixParser = Proc(AST::Expression?)
  # # Type alias for Proc objects used in infix notation parsing
  alias InfixParser = Proc(AST::Expression, AST::Expression)

  # Enum representing the precedence order of operators in Drizzle.
  # Lower precedence operators will have a lower integer value, allowing for easy comparisons between precedences.
  enum Precedence
    # Default
    LOWEST
    # `==`
    EQUALS
    # `>` or `<`
    LESSGREATER
    # `+` or `-`
    SUM
    # `*` or `/`
    PRODUCT
    # `-x`
    PREFIX
    # `func(x)`
    CALL
  end

  # Mapping of TokenTypes to Precedence values to use in infix expression parsing
  PrecedenceMap = {
    TokenType::EQ         => Precedence::EQUALS,
    TokenType::NOT_EQ     => Precedence::EQUALS,
    TokenType::LT         => Precedence::LESSGREATER,
    TokenType::GT         => Precedence::LESSGREATER,
    TokenType::PLUS       => Precedence::SUM,
    TokenType::MINUS      => Precedence::SUM,
    TokenType::ASTERISK   => Precedence::PRODUCT,
    TokenType::SLASH      => Precedence::PRODUCT,
    TokenType::LEFT_PAREN => Precedence::CALL,
  }

  # A Parser reads in the tokens generated by a `Lexer` and constructs an Abstract Syntax Tree (AST) built from what it finds.
  class Parser
    @lexer : Lexer
    @current : Token
    @peek : Token
    @errors : Array(String)
    @prefix_parsers : Hash(TokenType, PrefixParser)
    @infix_parsers : Hash(TokenType, InfixParser)

    def initialize(@lexer : Lexer)
      # Read the first two tokens to set up curr and peek variables
      @current = @lexer.get_next_token
      @peek = @lexer.get_next_token
      @errors = [] of String
      @prefix_parsers = {} of TokenType => PrefixParser
      @infix_parsers = {} of TokenType => InfixParser
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
      add_prefix TRUE, parse_boolean_literal
      add_prefix FALSE, parse_boolean_literal
      add_prefix LEFT_PAREN, parse_grouped_expression

      # Infix Parsers
      add_infix PLUS, parse_infix_expression
      add_infix MINUS, parse_infix_expression
      add_infix ASTERISK, parse_infix_expression
      add_infix SLASH, parse_infix_expression
      add_infix EQ, parse_infix_expression
      add_infix NOT_EQ, parse_infix_expression
      add_infix LT, parse_infix_expression
      add_infix GT, parse_infix_expression
      add_infix LEFT_PAREN, parse_call_expression
    end

    # Register a TokenType with a parser function that is run when the TokenType is discovered in a spot for prefix notation
    def register_prefix(token_type : TokenType, func : PrefixParser)
      @prefix_parsers[token_type] = func
    end

    # Register a TokenType with a parser function that is run when the TokenType is discovered in a spot for infix notation
    def register_infix(token_type : TokenType, func : InfixParser)
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
      # If we call this method with an EOL token, skip it
      while @current.token_type.eol?
        self.next_token
      end
      # If skipping an EOL token ends us up at the EOF token, then return nil
      if @current.token_type.eof?
        return nil
      end

      # Generate the right kind of statement
      case @current.token_type
      when TokenType::LET
        return self.parse_let_statement
      when TokenType::RETURN
        return self.parse_return_statement
      when TokenType::IF
        return self.parse_if_statement
      when TokenType::FUNCTION
        return self.parse_function
      end
      # Work under the assumption that it could be an expression statement
      return self.parse_expression_statement
    end

    # Attempt to parse a `let` statement found at the current token, returning the node if possible, or nil if not
    def parse_let_statement : AST::Let?
      # Ensure that the token setup is how we need it to be for a let statement: let <ident>: <ident> = <exp>
      token = @current

      eat_or_return_nil IDENTIFIER

      # Generate an Identifier node for the name
      name_token = @current

      # Expect a colon token next
      eat_or_return_nil COLON
      # The COLON token is ignored when building a let statement node but it has to be there

      # Expect another identifier here
      eat_or_return_nil IDENTIFIER

      # Generate an Identifier node for the type
      datatype = AST::Identifier.new @current, @current.literal
      name = AST::TypedIdentifier.new name_token, name_token.literal, datatype

      # Eat the assign token
      eat_or_return_nil ASSIGN
      # Skip the ASSIGN token also
      self.next_token

      expression = self.parse_expression Precedence::LOWEST
      if expression.nil?
        return nil
      end

      return AST::Let.new token, name, expression
    end

    # Attempt to parse a `return` statement found at the current token, returning the node if possible, or nil if not
    def parse_return_statement : AST::Return?
      token = @current

      # Get the next token
      self.next_token

      expression : AST::Expression? = nil
      if !@current.token_type.eol?
        expression = self.parse_expression Precedence::LOWEST
      end

      # Create and return the node
      return AST::Return.new token, expression
    end

    # Attempt to parse an 'if' statement found at the current token, returning the node if possible, or nil if not.
    #
    # The `check_alternatives` flag states whether the current call should check for `elsif` and `else` tokens. We can use this to parse `elsif` blocks recursively.
    def parse_if_statement(check_alternatives : Bool = true) : AST::IfStatement?
      token = @current

      # Expect a left parenthesis containing the condition
      eat_or_return_nil LEFT_PAREN
      # Move on to the first token of the conditional before parsing it
      self.next_token

      # Get the expression for the conditional
      condition = self.parse_expression(Precedence::LOWEST).not_nil!

      # Expect a right parenthesis to close the condition
      eat_or_return_nil RIGHT_PAREN

      # Expect a LEFT_BRACE to start the block
      eat_or_return_nil LEFT_BRACE

      # Parse the block statement
      consequence = self.parse_block_statement

      # Return now if we were told not to check alternatives
      if !check_alternatives
        return AST::IfStatement.new token, condition, consequence
      end

      # Otherwise, carry on and check the rest

      # Parse `elsif`s recursively
      alt_consequences = [] of AST::IfStatement
      alt : AST::BlockStatement? = nil
      # If the peek token is an elsif token, then move to it and then start parsing some elsif expressions recursively
      if @peek.token_type.elsif?
        self.next_token
        while @current.token_type.elsif?
          alt_stmnt = self.parse_if_statement false
          if !alt_stmnt.nil?
            alt_consequences << alt_stmnt
          end
        end
      end

      # Check for handling else
      if @peek.token_type.else?
        self.next_token
        eat_or_return_nil LEFT_BRACE
        alt = self.parse_block_statement
      end

      return AST::IfStatement.new token, condition, consequence, alt_consequences, alt
    end

    # Attempt to parse a function found at the current token, returning the node if possible, or nil if not
    # `def name((name: type)*) -> type block`
    def parse_function : AST::Function?
      token = @current

      # Get the name of the function
      eat_or_return_nil IDENTIFIER

      name = AST::Identifier.new @current, @current.literal

      # Get the parameter list
      eat_or_return_nil LEFT_PAREN
      # This function ensures there is a right paren afterwards so we don't need to check it here
      params = self.parse_function_parameters
      if params.nil?
        return nil
      end

      # Get the return type (if one is supplied)
      return_type : AST::Identifier? = nil
      if @peek.token_type.return_type?
        eat_or_return_nil RETURN_TYPE
        eat_or_return_nil IDENTIFIER
        return_type = AST::Identifier.new @current, @current.literal
      end

      # Get the function body
      eat_or_return_nil LEFT_BRACE
      body = self.parse_block_statement

      return AST::Function.new token, name, params, return_type, body
    end

    # Attempt to parse a block statement found at the current token, returning the node if possible, or nil if not
    def parse_block_statement : AST::BlockStatement?
      token = @current
      stmnts = [] of AST::Statement

      # Skip the left brace token that current should be on right now
      self.next_token

      # Loop until we find a RIGHT_BRACE or EOF token
      while !(@current.token_type.right_brace? || @current.token_type.eof?)
        stmnt = self.parse_statement
        if !stmnt.nil?
          stmnts << stmnt
        end
        self.next_token
        # Ignore EOL tokens here too to avoid running into any issues when checking for the RIGHT_BRACE over multiple lines
        while @current.token_type.eol?
          self.next_token
        end
      end
      return AST::BlockStatement.new token, stmnts
    end

    # Parse the parameter list for a function and return an array of `AST::TypedIdentifier` instances representing the parameters
    def parse_function_parameters : Array(AST::TypedIdentifier)?
      params = [] of AST::TypedIdentifier
      # If the param list is empty, return an empty array after moving the token on
      if @peek.token_type.right_paren?
        self.next_token
        return params
      end

      # If not, gather the params into the array and return it

      # Move off the left_paren token onto the first identifier
      self.next_token
      # Generate the first typed identifier and add it to the array
      param = self.parse_typed_identifier
      if param.nil?
        return nil
      end
      params << param

      # Loop while our peek token is a comma
      while @peek.token_type.comma?
        # Move the current token to the start of the next identifier
        self.next_token
        self.next_token
        # Parse the next param
        param = self.parse_typed_identifier
        if param.nil?
          return nil
        end
        params << param
      end

      # Ensure that there is a right paren at the end of the param list
      eat_or_return_nil RIGHT_PAREN

      return params
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
      # Prefix expressions, or LHS of infix expressions
      prefix_parser = @prefix_parsers.fetch @current.token_type, nil
      if prefix_parser.nil?
        @errors << "SyntaxError: No prefix parser function found for #{@current.token_type}\n\t#{@current.file_name} at line #{@current.line_num}, char #{@current.char_num}"
        return nil
      end
      left_exp = prefix_parser.not_nil!.call

      # Check for infix expression parsing until we reach a higher precedence token or the end of the line
      while !@peek.token_type.eol? && precedence.value < (PrecedenceMap.fetch @peek.token_type, Precedence::LOWEST).value
        # Parse an infix expression given what we've already parsed
        infix_parser = @infix_parsers.fetch @peek.token_type, nil
        if infix_parser.nil?
          # Just return the left exp, means that the found token isn't an infix operation
          return left_exp
        end
        # Update the current token and parse the infix expression if we reach this point
        self.next_token
        left_exp = infix_parser.not_nil!.call(left_exp.not_nil!).not_nil!
      end

      return left_exp
    end

    # Expression parser methods

    # Parse an identifier found at the current token
    # `name`
    def parse_identifier : AST::Expression
      return AST::Identifier.new @current, @current.literal
    end

    # Parse a typed identifier found at the current token
    # `name: datatype`
    def parse_typed_identifier : AST::TypedIdentifier?
      name = @current
      eat_or_return_nil COLON
      # Skip the colon
      self.next_token
      datatype = AST::Identifier.new @current, @current.literal
      return AST::TypedIdentifier.new name, name.literal, datatype
    end

    # Parse an integer found at the current token
    # `integer`
    def parse_integer_literal : AST::Expression
      # This function only gets called on an INTEGER type token, which we know has to be an integer
      return AST::IntegerLiteral.new @current, @current.literal.to_i64
    end

    # Parse a boolean found at the current token
    # `boolean`
    def parse_boolean_literal : AST::Expression
      return AST::BooleanLiteral.new @current, @current.token_type.true?
    end

    # Parse a prefix expression found at the current token
    # `operator expression`
    def parse_prefix_expression : AST::Expression
      token = @current
      operator = @current.literal
      self.next_token
      right = self.parse_expression Precedence::PREFIX
      return AST::PrefixExpression.new token, operator, right
    end

    # Parse a grouped expression found at the current token
    # `(expression)`
    def parse_grouped_expression : AST::Expression?
      self.next_token
      # Lower the precedence for the next pass so that it all gets grouped inside these parentheses
      exp = self.parse_expression Precedence::LOWEST
      # Expect a RIGHT_PAREN token
      eat_or_return_nil RIGHT_PAREN
      return exp
    end

    # Parse an infix expression found at the current token
    # `expression operator expression`
    def parse_infix_expression(left : AST::Expression) : AST::Expression
      token = @current
      operator = @current.literal
      precedence = PrecedenceMap.fetch @current.token_type, Precedence::LOWEST
      self.next_token
      right = self.parse_expression precedence
      return AST::InfixExpression.new token, left, operator, right
    end

    # Parse a call expression found at the current token
    # `identifier argument_list`
    def parse_call_expression(left : AST::Expression) : AST::Expression
      token = @current
      arguments = self.parse_call_arguments
      return AST::CallExpression.new token, left.as(AST::Identifier), arguments
    end

    # Parse an argument list for a call expression
    # `(expression*)`
    def parse_call_arguments : Array(AST::Expression)
      args = [] of AST::Expression
      if @peek.token_type.right_paren?
        self.next_token
        return args
      end

      self.next_token
      # Parse an expression and add it to the array
      exp = self.parse_expression(Precedence::LOWEST)
      if exp.nil?
        return [] of AST::Expression
      else
        args << exp
      end

      # Loop while the peek token is a comma
      while @peek.token_type.comma?
        # Skip the comma entirely and parse the next expression
        self.next_token
        self.next_token
        exp = self.parse_expression(Precedence::LOWEST)
        if exp.nil?
          return [] of AST::Expression
        else
          args << exp
        end
      end

      # Ensure the peek token is a right paren. If it is, advance the tokens, if not add an error
      # I'm not going to use my eat macro here to avoid having to make the return type nilable which will cause a lot of changes to have to be made
      if !self.eat? TokenType::RIGHT_PAREN
        return [] of AST::Expression
      end
      return args
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
