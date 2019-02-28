require "./spec_helper"

# Helper for testing eval function
def test_eval(input : String)
  Drizzle::Object::Object
  lexer = Drizzle::Lexer.new input
  parser = Drizzle::Parser.new lexer
  program = parser.parse_program
  env = Drizzle::Environment.new
  return Drizzle::Evaluator.eval program, env
end

# helper for testing integer values
def test_integer(output : Drizzle::Object::Object, expected : Int64)
  output = output.as(Drizzle::Object::Integer).value
  output.should eq expected
end

# helper for testing boolean values
def test_boolean(output : Drizzle::Object::Object, expected : Bool)
  output = output.as(Drizzle::Object::Boolean).value
  output.should eq expected
end

def test_null(output : Drizzle::Object::Object)
  output.object_type.should eq Drizzle::Object::ObjectType::NULL
end

# Spec for the evaluator
describe Drizzle::Evaluator do
  it "correctly evaluates self evaluating integer expressions" do
    tests = {
      {"5", 5_i64},
      {"10", 10_i64},
      {"-5", -5_i64},
      {"-10", -10_i64},
      {"5 + 5 + 5 + 5 - 10", 10_i64},
      {"2 * 2 * 2 * 2 * 2", 32_i64},
      {"-50 + 100 + -50", 0_i64},
      {"50 / 2 * 2 + 10", 60_i64},
      {"2 * (5 + 10)", 30_i64},
      {"3 * 3 * 3 + 10", 37_i64},
      {"(5 + 10 * 2 + 15 / 3) * 2 + - 10", 50_i64},
    }

    tests.each do |test|
      evaluated = test_eval test[0]
      test_integer evaluated, test[1]
    end
  end

  it "correctly evaluates self evaluating boolean expressions" do
    tests = {
      {"true", true},
      {"false", false},
      {"1 < 2", true},
      {"1 > 2", false},
      {"1 < 1", false},
      {"1 > 1", false},
      {"1 == 1", true},
      {"1 != 1", false},
      {"1 == 2", false},
      {"1 != 2", true},
      {"true == true", true},
      {"false == false", true},
      {"true == false", false},
      {"false == true", false},
      {"true != false", true},
      {"false != true", true},
      {"true != true", false},
      {"false != false", false},
      {"(1 < 2) == true", true},
      {"(1 < 2) == false", false},
      {"(1 > 2) == true", false},
      {"(1 > 2) == false", true},
    }

    tests.each do |test|
      evaluated = test_eval test[0]
      test_boolean evaluated, test[1]
    end
  end

  it "correctly evaluates prefix not operators" do
    tests = {
      {"not true", false},
      {"not false", true},
      {"not 5", false},
      {"not not true", true},
      {"not not false", false},
      {"not not 5", true},
    }

    tests.each do |test|
      evaluated = test_eval test[0]
      test_boolean evaluated, test[1]
    end
  end

  it "correctly evaluates conditionals" do
    # This one could cause an issue because of monkey's implicit returns
    tests = {
      {"if (true) { return 10 }", 10_i64},
      {"if (false) { return 10 }", nil},
      {"if (1) { return 10 }", 10_i64},
      {"if (1 < 2) { return 10 }", 10_i64},
      {"if (1 > 2) { return 10 }", nil},
      {"if (1 > 2) { return 10 } else { return 20 }", 20_i64},
      {"if (1 < 2) { return 10 } else { return 20 }", 10_i64},
      {"if (1 > 2) { return 10 } elsif (2 == 2) { return 15 } else { return 20 }", 15_i64},
      {"if (1 > 2) { 10 }", nil},
    }

    tests.each do |test|
      evaluated = test_eval test[0]
      if test[1].nil?
        test_null evaluated
      else
        test_integer evaluated, test[1].not_nil!
      end
    end
  end

  it "correctly evaluates return statements" do
    tests = {
      {"return 10", 10_i64},
      {"return 10\n9", 10_i64},
      {"return 2 * 5\n9", 10_i64},
      {"9\nreturn 2 * 5\n9", 10_i64},
      {"if (10 > 1) {
          if (10 > 1) {
            return 10
          }
          return 1
        }", 10_i64},
    }
    tests.each do |test|
      evaluated = test_eval test[0]
      test_integer evaluated, test[1]
    end
  end

  it "correctly handles and displays error messages (without checking stack trace)" do
    tests = {
      {
        "5 + true",
        "type mismatch: INTEGER + BOOLEAN",
      },
      {
        "5 + true\n5",
        "type mismatch: INTEGER + BOOLEAN",
      },
      {
        "-true",
        "unknown operator: -BOOLEAN",
      },
      {
        "true + false",
        "unknown operator: BOOLEAN + BOOLEAN",
      },
      {
        "5\ntrue + false\n5",
        "unknown operator: BOOLEAN + BOOLEAN",
      },
      {
        "if (10 > 1) { return true + false }",
        "unknown operator: BOOLEAN + BOOLEAN",
      },
      {
        "if (10 > 1) {
          if (10 > 1) {
            return true + false
          }
          return 1
        }",
        "unknown operator: BOOLEAN + BOOLEAN",
      },
      {"foobar", "identifier not found: foobar"},
      {"'hello' - 'world'", "unknown operator: STRING - STRING"},
    }

    tests.each do |test|
      evaluated = test_eval test[0]
      evaluated.object_type.should eq Drizzle::Object::ObjectType::ERROR
      evaluated.as(Drizzle::Object::Error).message.should eq test[1]
    end
  end

  it "correctly handles let statements and bindings" do
    tests = {
      {"let a: int = 5\n return a\n", 5_i64},
      {"let a: int = 5 * 5\n return a\n", 25_i64},
      {"let a: int = 5\n let b: int = a\n return b\n", 5_i64},
      {"let a: int = 5\n let b: int = a\n let c: int = a + b + 5\n return c\n", 15_i64},
    }
    tests.each do |test|
      evaluated = test_eval test[0]
      test_integer evaluated, test[1]
    end
  end

  it "correctly evaluates function declarations" do
    input = "def add_two(x: num) -> num { return x + 2 }"
    evaluated = test_eval input
    evaluated.object_type.should eq Drizzle::Object::ObjectType::FUNCTION
    function = evaluated.as Drizzle::Object::Function
    function.parameters.size.should eq 1
    function.parameters[0].to_s.should eq "x: num"
    function.return_type.to_s.should eq "num"
    function.body.to_s.should eq "return (x + 2)"
  end

  it "correctly handles function invocation" do
    tests = {
      {"def identity(x: any) -> any { return x }\nidentity(5)", 5_i64},
      {"def double(x: num) -> num { return x * 2 }\ndouble(5)", 10_i64},
      {"def add(x: num, y: num) -> num { return x + y }\nadd(5, 5)", 10_i64},
      {"def add(x: num, y: num) -> num { return x + y }\nadd(5 + 5, add(5, 5))", 20_i64},
      # First Class function test because why not
      # For now, due to an issue with tokenizing function types, properly typing f in the following example does not work
      # f's type should be f: (num -> num)
      {"def double(x: num) -> num { return x * 2 }\ndef apply(x: num, f: func) -> num { return f(x) }\napply(5, double)", 10_i64},
    }
    tests.each do |test|
      evaluated = test_eval test[0]
      test_integer evaluated, test[1]
    end
  end

  it "correctly handles closures" do
    input = "
    def new_adder(x: num) -> func {
      def wrapped(y: num) -> num {
        return x + y
      }
      return wrapped
    }

    let add_two: func = new_adder(2)
    add_two(2)"
    evaluated = test_eval input
    test_integer evaluated, 4_i64
  end

  it "correctly evaluates string literals" do
    input = "'Hello World!'"
    evaluated = test_eval input
    evaluated.object_type.should eq Drizzle::Object::ObjectType::STRING
    string = evaluated.as Drizzle::Object::StringObj
    string.value.should eq "Hello World!"
  end

  it "can handle string concatenation using the `+` operator" do
    input = "'Hello' + ' ' + 'World!'"
    evaluated = test_eval input
    evaluated.object_type.should eq Drizzle::Object::ObjectType::STRING
    string = evaluated.as Drizzle::Object::StringObj
    string.value.should eq "Hello World!"
  end
end
