require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::Return do
  it "correctly generates return statement nodes from `examples/example4.drzl`" do
    file_name = "examples/example4.drzl"
    input_file = File.open file_name

    # Create a lexer and a parser to test with
    lexer = Drizzle::Lexer.new input_file
    parser = Drizzle::Parser.new lexer

    # Parse the program node
    program = parser.parse_program
    check_parser_errors parser

    # Do initial checks of the created program node
    program.statements.size.should eq 3

    # Check that all the statements are return statements
    program.statements.each do |statement|
      statement.literal.should eq "return"
      return_statement = statement.as(Drizzle::AST::Return)
      return_statement.literal.should eq "return"
    end
  end
end
