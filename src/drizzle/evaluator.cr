require "./ast/*"
require "./object/object"

module Drizzle
  # Module containing an overloaded evaluation function that evaluates all the various node types
  class Evaluator
    # eval method for integer literal nodes
    def self.eval(node : AST::IntegerLiteral) : Object::Object?
      return Object::Integer.new node.value
    end

    # catch all eval method
    def self.eval(node : AST::Node) : Object::Object?
      return nil
    end
  end
end
