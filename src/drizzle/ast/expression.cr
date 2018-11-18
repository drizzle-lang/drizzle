require "./node"

module Drizzle
  module AST
    # Abstract class set up as the parent for all nodes that represent expressions
    #
    # An expression is anything that gives a value
    abstract class Expression < Node
    end
  end
end
