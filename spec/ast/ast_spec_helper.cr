require "../spec_helper"

# Helper function to test if an expression is an IntegerLiteral and has the expected value
def test_integer_literal(exp : Drizzle::AST::Expression?, expected : Int64)
  int = exp.as(Drizzle::AST::IntegerLiteral)
  int.value.should eq expected
  int.literal.should eq expected.to_s
end
