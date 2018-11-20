require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::Identifier do
  it "correctly parsed when encountered and generates the correct Node type for the input `foobar`" do
    input = "foobar"

    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser

    # Check that the correct number and type of statements have been created
    program.statements.size.should eq 1
    expr_statement = program.statements[0].as(Drizzle::AST::ExpressionStatement)
    ident = expr_statement.expression.as(Drizzle::AST::Identifier)
    ident.value.should eq input
    ident.literal.should eq input
  end
end
