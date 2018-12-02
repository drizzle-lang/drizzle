require "./ast_spec_helper"
require "../spec_helper"

# Test helper that tests that a given statement is a let statement, and the identifiers involved are correct
def test_let_statement(statement : Drizzle::AST::Statement, name : String, datatype : String, value : String)
  statement.literal.should eq "let"
  let_statement = statement.as(Drizzle::AST::Let)
  let_statement.name.value.should eq name
  let_statement.datatype.value.should eq datatype
  let_statement.name.literal.should eq name
  let_statement.value.as(Drizzle::AST::IntegerLiteral).value.should eq value.to_i64
end

describe Drizzle::AST::Let do
  it "correctly generates let statement nodes from `examples/example3.drzl`" do
    file_name = "examples/example3.drzl"
    input_file = File.open file_name

    # Create a lexer and a parser
    lexer = Drizzle::Lexer.new input_file
    parser = Drizzle::Parser.new lexer

    # Parse the program node
    program = parser.parse_program
    check_parser_errors parser
    # Check that the program node was successfully parsed
    program.nil?.should be_false
    program.statements.size.should eq 3

    # Check the generated identifiers against the expected ones
    expected_identifiers = [
      ["x", "int", "5"],
      ["y", "int", "10"],
      ["foobar", "int", "838383"],
    ]

    expected_identifiers.each.with_index do |expected, i|
      statement = program.statements[i]
      test_let_statement statement, expected[0], expected[1], expected[2]
    end
  end
end
