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
end
