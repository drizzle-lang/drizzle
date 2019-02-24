require "./ast/*"
require "./object/*"

module Drizzle
  # Module containing an overloaded evaluation function that evaluates all the various node types
  class Evaluator
    # Since there are only two possible options for booleans, create them both here and reuse these instances
    @@TRUE = Object::Boolean.new true
    @@FALSE = Object::Boolean.new false
    # Same can be said for NULL
    @@NULL = Object::Null.new

    # eval method for program nodes, the starting point of any drizzle program
    def self.eval(node : AST::Program) : Object::Object
      return Evaluator.eval node.statements[0]
    end

    # eval method for expression statement nodes, which represent expressions on their own (e.g. an integer literal on its own)
    def self.eval(node : AST::ExpressionStatement) : Object::Object
      return Evaluator.eval node.expression
    end

    # eval method for integer literal nodes
    def self.eval(node : AST::IntegerLiteral) : Object::Object
      return Object::Integer.new node.value
    end

    # eval method for boolean literal nodes
    def self.eval(node : AST::BooleanLiteral) : Object::Object
      if node.value
        return @@TRUE
      else
        return @@FALSE
      end
    end

    # temp catchall method
    def self.eval(node : AST::Node) : Object::Object
      return Object::Null.new
    end

    # temp handling for nil nodes since expressionstatement can have a nil expression
    def self.eval(node : Nil) : Object::Object
      return Object::Null.new
    end
  end
end
