module Drizzle
  # The AST module contains classes that represent each of the different types of nodes that can be encountered when parsing the Token output from a `Lexer`
  module AST
    # Abstract base class that all Nodes inherit from, to give a single parent point
    abstract class Node
      # Returns a string form of the literal for this node.
      abstract def literal : String

      # Return a string form of the node
      # Used to print out the node in a nice way.
      abstract def to_s : String
    end
  end
end
