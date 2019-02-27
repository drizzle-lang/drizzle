require "./spec_helper"

# Helper for testing eval function
def test_eval(input : String)
  Drizzle::Object::Object
  lexer = Drizzle::Lexer.new input
  parser = Drizzle::Parser.new lexer
  program = parser.parse_program
  return Drizzle::Evaluator.eval program
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
  output.object_type.should eq "NULL"
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
      {"if (true) { 10 }", 10_i64},
      {"if (false) { 10 }", nil},
      {"if (1) { 10 }", 10_i64},
      {"if (1 < 2) { 10 }", 10_i64},
      {"if (1 > 2) { 10 }", nil},
      {"if (1 > 2) { 10 } else { 20 }", 20_i64},
      {"if (1 < 2) { 10 } else { 20 }", 10_i64},
      {"if (1 > 2) { 10 } elsif (2 == 2) { 15 } else { 20 }", 15_i64},
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
    }
    tests.each do |test|
      evaluated = test_eval test[0]
      test_integer evaluated, test[1]
    end
  end
end
