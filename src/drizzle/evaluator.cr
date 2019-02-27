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
      # loop through the program's statements, returning a specified return value or the final value encountered
      # this is to allow single statement programs to still work
      result = @@NULL
      node.statements.each do |statement|
        result = eval statement
        case result.object_type
        when Object::RETURN_VALUE_TYPE
          return result.as(Object::ReturnValue).value
        when Object::ERROR_TYPE
          return result
        end
      end
      return result
    end

    # eval method for block nodes, which represent a collection of statements
    def self.eval(node : AST::BlockStatement) : Object::Object
      # loop through the block, returning a specified return statement and evaluating any other statements
      # found before that point
      node.statements.each do |statement|
        result = eval statement
        if result.object_type == Object::RETURN_VALUE_TYPE || result.object_type == Object::ERROR_TYPE
          # Unlike the program block, don't unwrap here
          return result
        end
      end
      return @@NULL
    end

    # eval method for if statements
    def self.eval(node : AST::IfStatement) : Object::Object
      return eval_if_expression node
    end

    # eval method for return statements
    def self.eval(node : AST::Return) : Object::Object
      return_value = eval node.value
      return Object::ReturnValue.new return_value
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

    # eval method for infix expression nodes
    def self.eval(node : AST::InfixExpression) : Object::Object
      left = eval node.left
      right = eval node.right
      return eval_infix_expression node.operator, left, right
    end

    # eval method for integer literal nodes
    def self.eval(node : AST::IntegerLiteral) : Object::Object
      return Object::Integer.new node.value
    end

    # eval method for boolean literal nodes
    def self.eval(node : AST::BooleanLiteral) : Object::Object
      return convert_native_bool_to_object node.value
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
    private def self.eval_prefix_expression(op : String, value : Object::Object) : Object::Object
      case op
      when "not"
        return eval_boolean_negation value
      when "-"
        return eval_arithmetic_negation value
      else
        return new_error "unknown operator: #{op}#{value.object_type}"
      end
    end

    # eval method for infix stuff
    private def self.eval_infix_expression(op : String, left : Object::Object, right : Object::Object) : Object::Object
      if left.object_type == Object::INTEGER_TYPE && right.object_type == Object::INTEGER_TYPE
        return eval_arithmetic_infix_expression op, left, right
        # Because there is only two comparison operators for booleans, we can handle them here
        # These comparisons use pointer arithmetic because we can since we only have one instance of true, false or null
      elsif op == "=="
        return convert_native_bool_to_object(left == right)
      elsif op == "!="
        return convert_native_bool_to_object(left != right)
      elsif left.object_type != right.object_type
        return new_error "type mismatch: #{left.object_type} #{op} #{right.object_type}"
      else
        return new_error "unknown operator: #{left.object_type} #{op} #{right.object_type}"
      end
    end

    # eval method for conditionals
    private def self.eval_if_expression(node : AST::IfStatement) : Object::Object
      condition = eval node.condition
      if truthy? condition
        result = eval node.consequence
        if result.object_type == Object::RETURN_VALUE_TYPE
          # return the inner value
          return result
        else
          return @@NULL
        end
      end
      # Now check if there are alt consequences
      node.alt_consequences.each do |alt|
        condition = eval alt.condition
        if truthy? condition
          result = eval alt.consequence
          if result.object_type == Object::RETURN_VALUE_TYPE
            # return the inner value
            return result
          else
            return @@NULL
          end
        end
      end

      # If we get here, evaluate the else if there is one
      if !node.alternative.nil?
        result = eval node.alternative
        if result.object_type == Object::RETURN_VALUE_TYPE
          # return the inner value
          return result
        else
          return @@NULL
        end
      else
        return @@NULL
      end
    end

    # eval method for handling boolean negation
    private def self.eval_boolean_negation(value : Object::Object) : Object::Object
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
    private def self.eval_arithmetic_negation(value : Object::Object) : Object::Object
      if value.object_type != Object::INTEGER_TYPE
        return new_error "unknown operator: -#{value.object_type}"
      end
      # Cast to an integer and get the value
      int_value = value.as(Object::Integer).value
      return Object::Integer.new -int_value
    end

    # eval method for handling arithmetic based infix expressions (expressions that result in a number)
    private def self.eval_arithmetic_infix_expression(op : String, left : Object::Object, right : Object::Object) : Object::Object
      left_val = left.as(Object::Integer).value
      right_val = right.as(Object::Integer).value

      case op
      when "+"
        return Object::Integer.new left_val + right_val
      when "-"
        return Object::Integer.new left_val - right_val
      when "*"
        return Object::Integer.new left_val * right_val
      when "/"
        return Object::Integer.new left_val / right_val
      when "<"
        return convert_native_bool_to_object left_val < right_val
      when ">"
        return convert_native_bool_to_object left_val > right_val
      when "=="
        return convert_native_bool_to_object left_val == right_val
      when "!="
        return convert_native_bool_to_object left_val != right_val
      else
        return new_error "unknown operator: #{left.object_type} #{op} #{right.object_type}"
      end
    end

    # other helpers

    # convert crystal bool to drizzle object representation
    private def self.convert_native_bool_to_object(value : Bool) : Object::Object
      if value
        return @@TRUE
      else
        return @@FALSE
      end
    end

    # helper for determining truthiness of an object
    private def self.truthy?(value : Object::Object) : Bool
      # There's a bit missing from here imo but for now it should be fine
      case value
      when @@NULL
        return false
      when @@TRUE
        return true
      when @@FALSE
        return false
      else
        return true
      end
    end

    # helper for generating new tokens given a message
    private def self.new_error(message : String) : Object::Object
      # Extend this by adding the token that caused it to add more detail
      return Object::Error.new message
    end
  end
end
