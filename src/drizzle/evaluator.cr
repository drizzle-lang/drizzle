require "./environment"
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

    # Builtins definition
    # an alternative is to wrap the `env` arg in #eval(Program) with a builtins env
    # but this is the way the book does it so that's how I'll leave it for now
    @@BUILTINS : Hash(String, Object::Builtin) = {
      "len" => Object::Builtin.new ->(args : Array(Object::Object)) {
        # wrap crystal's .size method for iterables
        if args.size != 1
          return new_error "ArgumentError: Incorrect number of arguments to `len`, expected 1, received #{args.size}"
        end
        # Do stuff based on the type of the object
        case args[0].object_type
        when .string?
          return Object::Integer.new args[0].as(Object::StringObj).value.size.to_i64
        else
          return new_error "ArgumentError: `len` received an unsupported argument of type #{args[0].object_type}"
        end
      },
    }

    # eval method for program nodes, the starting point of any drizzle program
    def self.eval(node : AST::Program, env : Environment) : Object::Object
      # loop through the program's statements, returning a specified return value or the final value encountered
      # this is to allow single statement programs to still work
      result = @@NULL
      node.statements.each do |statement|
        result = eval statement, env
        case result.object_type
        when .return_value?
          return result.as(Object::ReturnValue).value
        when .error?
          return result
        end
      end
      return result
    end

    # eval method for block nodes, which represent a collection of statements
    def self.eval(node : AST::BlockStatement, env : Environment) : Object::Object
      # loop through the block, returning a specified return statement and evaluating any other statements
      # found before that point
      node.statements.each do |statement|
        result = eval statement, env
        if result.object_type.return_value? || result.object_type.error?
          # Unlike the program block, don't unwrap here
          return result
        end
      end
      return @@NULL
    end

    # eval method for if statements
    def self.eval(node : AST::IfStatement, env : Environment) : Object::Object
      return eval_if_expression node, env
    end

    # eval method for return statements
    def self.eval(node : AST::Return, env : Environment) : Object::Object
      return_value = eval node.value, env

      # check for errors
      if return_value.object_type.error?
        return return_value
      end

      return Object::ReturnValue.new return_value
    end

    # eval method for let statements
    def self.eval(node : AST::Let, env : Environment) : Object::Object
      # first evaluate the expression
      value = eval node.value, env

      # check for errors
      if value.object_type.error?
        return value
      end

      # now bind the stuff to the environment
      env.set node.name.value, value

      # in Drizzle, assignment will return the value as well (assignment is an expression, not a statement)
      # TODO - refactor let to be an expression and not a statement
      return value
    end

    # eval statement for function definitions
    def self.eval(node : AST::Function, env : Environment) : Object::Object
      # Just construct a function object wrapper around the AST node
      obj = Object::Function.new node.name, node.params, node.ret_type, node.body, env
      # Monkey defines functions with `let`s, we don't, so add the function to the symbol table
      env.set node.name.value, obj
      return obj
    end

    # eval method for expression statement nodes, which represent expressions on their own (e.g. an integer literal on its own)
    def self.eval(node : AST::ExpressionStatement, env : Environment) : Object::Object
      return eval node.expression, env
    end

    # eval method for prefix expression nddes
    def self.eval(node : AST::PrefixExpression, env : Environment) : Object::Object
      right = eval node.right, env

      # check for errors
      if right.object_type.error?
        return right
      end

      return eval_prefix_expression node.operator, right, env
    end

    # eval method for infix expression nodes
    def self.eval(node : AST::InfixExpression, env : Environment) : Object::Object
      left = eval node.left, env

      # check for errors
      if left.object_type.error?
        return left
      end

      right = eval node.right, env

      # check for errors
      if right.object_type.error?
        return right
      end

      return eval_infix_expression node.operator, left, right, env
    end

    # eval method for call expressions, formed as a result of calling a function
    def self.eval(node : AST::CallExpression, env : Environment) : Object::Object
      # First get the function we want to call
      function = eval node.function, env

      # check for errors
      if function.object_type.error?
        return function
      end

      # next, evaluate the expressions
      args = eval_expressions node.arguments, env

      # check for errors
      if args.size == 1 && args[0].object_type.error?
        return args[0]
      end

      # apply the function and return the result
      return apply_function function, args
    end

    # eval method for integer literal nodes
    def self.eval(node : AST::IntegerLiteral, env : Environment) : Object::Object
      return Object::Integer.new node.value
    end

    # eval method for boolean literal nodes
    def self.eval(node : AST::BooleanLiteral, env : Environment) : Object::Object
      return convert_native_bool_to_object node.value
    end

    # eval method for string literals
    def self.eval(node : AST::StringLiteral, env : Environment) : Object::Object
      return Object::StringObj.new node.value
    end

    # eval method for identifiers
    def self.eval(node : AST::Identifier, env : Environment) : Object::Object
      # Check if the name is in the env, if its not throw an error
      val = env.get node.value
      if val.nil?
        # check the builtin map before assuming there's an error
        val = @@BUILTINS[node.value]?
        if val.nil?
          return new_error "identifier not found: #{node.value}"
        else
          return val
        end
      else
        return val
      end
    end

    # temp catchall method
    def self.eval(node : AST::Node, env : Environment) : Object::Object
      return @@NULL
    end

    # temp handling for nil nodes since expressionstatement can have a nil expression
    def self.eval(node : Nil, env : Environment) : Object::Object
      return @@NULL
    end

    # non-node evaluation methods

    # evaluate an array of expressions
    private def self.eval_expressions(expressions : Array(AST::Expression), env : Environment) : Array(Object::Object)
      # iterate through the expressions and add the evaluated objects to an array
      result = [] of Object::Object
      expressions.each do |exp|
        evaluated = eval exp, env
        if evaluated.object_type.error?
          return [evaluated]
        end
        result << evaluated
      end
      return result
    end

    # eval method for prefix stuff
    private def self.eval_prefix_expression(op : String, value : Object::Object, env : Environment) : Object::Object
      case op
      when "not"
        return eval_boolean_negation value, env
      when "-"
        return eval_arithmetic_negation value, env
      else
        return new_error "unknown operator: #{op}#{value.object_type}"
      end
    end

    # eval method for infix stuff
    private def self.eval_infix_expression(op : String, left : Object::Object, right : Object::Object, env : Environment) : Object::Object
      if left.object_type.integer? && right.object_type.integer?
        return eval_arithmetic_infix_expression op, left, right, env
        # Because there is only two comparison operators for booleans, we can handle them here
        # These comparisons use pointer arithmetic because we can since we only have one instance of true, false or null
      elsif left.object_type.string? && right.object_type.string?
        return eval_string_infix_expression op, left, right, env
      elsif op == "=="
        return convert_native_bool_to_object left == right
      elsif op == "!="
        return convert_native_bool_to_object left != right
      elsif left.object_type != right.object_type
        return new_error "type mismatch: #{left.object_type} #{op} #{right.object_type}"
      else
        return new_error "unknown operator: #{left.object_type} #{op} #{right.object_type}"
      end
    end

    # eval method for conditionals
    private def self.eval_if_expression(node : AST::IfStatement, env : Environment) : Object::Object
      condition = eval node.condition, env

      # check for errors
      if condition.object_type.error?
        return condition
      end

      if truthy? condition
        result = eval node.consequence, env
        if result.object_type.return_value? || result.object_type.error?
          # return the inner value
          return result
        else
          return @@NULL
        end
      end
      # Now check if there are alt consequences
      node.alt_consequences.each do |alt|
        condition = eval alt.condition, env

        if condition.object_type.error?
          return condition
        end

        if truthy? condition
          result = eval alt.consequence, env
          if result.object_type.return_value? || result.object_type.error?
            # return the inner value
            return result
          else
            return @@NULL
          end
        end
      end

      # If we get here, evaluate the else if there is one
      if !node.alternative.nil?
        result = eval node.alternative, env
        if result.object_type.return_value? || result.object_type.error?
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
    private def self.eval_boolean_negation(value : Object::Object, env : Environment) : Object::Object
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
    private def self.eval_arithmetic_negation(value : Object::Object, env : Environment) : Object::Object
      if !value.object_type.integer?
        return new_error "unknown operator: -#{value.object_type}"
      end
      # Cast to an integer and get the value
      int_value = value.as(Object::Integer).value
      return Object::Integer.new -int_value
    end

    # eval method for handling arithmetic based infix expressions (expressions that result in a number)
    private def self.eval_arithmetic_infix_expression(op : String, left : Object::Object, right : Object::Object, env : Environment) : Object::Object
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

    # eval method for handling infix expressions for strings
    private def self.eval_string_infix_expression(op : String, left : Object::Object, right : Object::Object, env : Environment) : Object::Object
      left_val = left.as(Object::StringObj).value
      right_val = right.as(Object::StringObj).value
      case op
      when "+"
        return Object::StringObj.new "#{left_val}#{right_val}"
        # can add * handling later
      else
        return new_error "unknown operator: #{left.object_type} #{op} #{right.object_type}"
      end
      # unwrap the values between left and right, concatenate them and wrap them in a new string obj
    end

    # helper that manages setting up the env for a function, running it and returning the result
    private def self.apply_function(obj : Object::Object, args : Array(Object::Object)) : Object::Object
      # cast the function to either a function or builtin object
      case obj.object_type
      when .function?
        function = obj.as Object::Function
        # create an extended environment for the function
        extended_env = extend_function_env function, args
        # now evaluate the body of the function using the extended environment
        evaluated = eval function.body, extended_env
        # check if there was a return within the function and return either its value or null
        if evaluated.object_type.return_value?
          return evaluated.as(Object::ReturnValue).value
        else
          return @@NULL
        end
      when .builtin?
        function = obj.as(Object::Builtin).function
        return function.call args
      else
        return new_error "not a function: #{obj.object_type}"
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

    # helper for extending a function's environment with the values of its arguments
    private def self.extend_function_env(function : Object::Function, args : Array(Object::Object)) : Environment
      # Create a new env wrapped by the one stored in the function
      env = Environment.new function.env
      # for each of the supplied params, add the passed values to the new env
      function.parameters.each.with_index do |param, index|
        env.set param.value, args[index]
      end

      return env
    end
  end
end
