require "./node"

module Drizzle
  module AST
    # Abstract class set up as the parent for all nodes that represent statements
    #
    # A statement is anything that does not return a value
    abstract class Statement < Node
    end
  end
end
