require "../spec_helper"

# Helper function that ensures there are no parser errors.
#
# If there are, it will print them out
def check_parser_errors(parser : Drizzle::Parser)
  errors = parser.errors
  if errors.empty?
    return
  end

  errors.each do |err|
    puts err
  end

  errors.size.should eq 0
end

# Helper function to test if an expression is an IntegerLiteral and has the expected value
def test_integer_literal(exp : Drizzle::AST::Expression?, expected : Int64)
  int = exp.as(Drizzle::AST::IntegerLiteral)
  int.value.should eq expected
  int.literal.should eq expected.to_s
end
