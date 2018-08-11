module Sapphire
  # Enum of the various types of Tokens in the Sapphire language.
  # This enum is used for the creation of `Token` instances, and will use its helper methods to help in the parsing stages also.
  enum TokenType
    # Special Tokens

    # Token is generated from a string that Sapphire does not recognise
    ILLEGAL
    # End of file token
    EOF

    # Identifiers / Literals

    # Name of variable, function, type, etc
    IDENTIFIER
    # Integer literal
    INTEGER

    # Operators

    # Assignment operator for assigning value to a variable
    ASSIGN
    # Return type operator for specifying a functions return type
    RETURN_TYPE
    # Addition operator for adding two values together
    PLUS

    # Delimiters

    # Separating of items in a data structure / parameter list / etc.
    COMMA
    # Separating of identifier from type in the case of variables and parameters
    COLON
    # Opening of parameter lists and tuples, and of general brackets
    LEFT_PAREN
    # Closing of parameter lists and tuples, and of general brackets
    RIGHT_PAREN
    # Opening of code blocks i.e. functions, as well as opening of set and dict literals
    LEFT_BRACE
    # CLosing of code blocks i.e. functions, as well as closing of set and dict literals
    RIGHT_BRACE

    # Language keywords

    # Declaration of a variable
    LET
    # Definition of a function
    FUNCTION
    # Return value from a function
    RETURN
  end
end
