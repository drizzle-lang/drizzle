module Drizzle
  module Object
    # Enum defining the different types of Objects
    enum ObjectType
      # Base Object class
      OBJECT
      # Integers
      INTEGER
      # Booleans
      BOOLEAN
      # Null
      NULL
      # Return Value Wrapper
      RETURN_VALUE
      # Error Type
      ERROR
      # Function types
      FUNCTION
      # Strings
      STRING
      # Builtins
      BUILTIN
    end
    # Type definition for a built in function
    alias BuiltinFunction = Proc(Array(Object), Object)
  end
end
