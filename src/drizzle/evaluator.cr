require "./ast/*"
require "./object/object"

module Drizzle
  # Module containing an overloaded evaluation function that evaluates all the various node types
  class Evaluator
    # eval method for program nodes, the starting point of any drizzle program
    def self.eval(node : AST::Program) : Object::Object
      return Evaluator.eval node.statements[0]
    end

    # eval method for integer literal nodes
    def self.eval(node : AST::IntegerLiteral) : Object::Object
      return Object::Integer.new node.value
    end

    # temp catchall method
    def self.eval(node : AST::Node) : Object::Object
      return Object::Null.new
    end
  end
end
