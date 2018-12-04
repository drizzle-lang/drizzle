require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::IntegerLiteral do
  it "correctly parsed when encountered and generates the correct Node type for the input `5`" do
    input = "5"

    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser

    # Check that the correct number and type of statements have been created
    program.statements.size.should eq 1
    expr_statement = program.statements[0].as(Drizzle::AST::ExpressionStatement)
    int = expr_statement.expression.as(Drizzle::AST::IntegerLiteral)
    int.value.should eq input.to_i
    int.literal.should eq input
  end
end
