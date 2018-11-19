require "../spec_helper"

def test_let_statement(statement : Drizzle::AST::Statement, name : String)
  statement.literal.should eq "let"
  let_statement = statement.as(Drizzle::AST::Let)
  let_statement.name.value.should eq name
  let_statement.name.literal.should eq name
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
    # Check that the program node was successfully parsed
    program.nil?.should be_false
    program.statements.size.should eq 3

    # Check the generated identifiers against the expected ones
    expected_identifiers = [
      "x",
      "y",
      "foobar",
    ]

    expected_identifiers.each.with_index do |expected, i|
      statement = program.statements[i]
      test_let_statement statement, expected
    end
  end
end
