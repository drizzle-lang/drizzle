require "./spec_helper"

# Helper for testing eval function
def test_eval(input : String)
  Drizzle::Object::Object
  lexer = Drizzle::Lexer.new input
  parser = Drizzle::Parser.new lexer
  program = parser.parse_program
  return Drizzle::Evaluator.Eval program
end

# Spec for the evaluator
describe Drizzle::Evaluator do
  it "correctly evaluates self evaluating integer expressions" do
    tests = {
      {"5", 5},
      {"10", 10},
    }

    tests.each do |test|
      evaluated = test_eval test[0]
      evaluated.to_i64.should eq test[1]
    end
  end
end
