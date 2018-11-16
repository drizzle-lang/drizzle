module Drizzle
  module AST
    abstract class Node
      abstract def literal : String
    end
  end
end
