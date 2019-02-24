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
      return eval node.statements[0]
    end

    # eval method for expression statement nodes, which represent expressions on their own (e.g. an integer literal on its own)
    def self.eval(node : AST::ExpressionStatement) : Object::Object
      return eval node.expression
    end

    # eval method for prefix expression nddes
    def self.eval(node : AST::PrefixExpression) : Object::Object
      right = Evaluator.eval node.right
      return eval_prefix_expression node.operator, right
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
      return @@NULL
    end

    # temp handling for nil nodes since expressionstatement can have a nil expression
    def self.eval(node : Nil) : Object::Object
      return @@NULL
    end

    # non-node evaluation methods

    # eval method for prefix stuff
    def self.eval_prefix_expression(op : String, value : Object::Object) : Object::Object
      case op
      when "not"
        return eval_boolean_negation value
      when "-"
        return eval_arithmetic_negation value
      else
        return @@NULL
      end
    end

    # eval method for handling boolean negation
    def self.eval_boolean_negation(value : Object::Object) : Object::Object
      case value
      when @@TRUE
        return @@FALSE
      when @@FALSE
        return @@TRUE
      when @@NULL
        return @@TRUE
      else
        return @@FALSE
      end
    end

    # eval method for handling arithmetic negation
    def self.eval_arithmetic_negation(value : Object::Object) : Object::Object
      if value.object_type != Object::INTEGER_TYPE
        return @@NULL
      end
      # Cast to an integer and get the value
      int_value = value.as(Object::Integer).value
      return Object::Integer.new -int_value
    end
  end
end
