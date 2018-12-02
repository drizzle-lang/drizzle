require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::CallExpression do
  it "correctly parses a call expression" do
    input = "add(1, 2 * 3, 4 + 5)"
    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser

    # Check through the AST for the correct layout given our input
    program.statements.size.should eq 1
    stmnt = program.statements[0].as Drizzle::AST::ExpressionStatement
    exp = stmnt.expression.as Drizzle::AST::CallExpression

    # Check the identifier and the argument list for the expression
    exp.function.as(Drizzle::AST::Identifier).value.should eq "add"
    exp.arguments.size.should eq 3

    # Argument 1: 1
    exp.arguments[0].as(Drizzle::AST::IntegerLiteral).value.should eq 1_i64

    # Argument 2: 2 * 3
    mul_arg = exp.arguments[1].as Drizzle::AST::InfixExpression
    mul_arg.left.not_nil!.as(Drizzle::AST::IntegerLiteral).value.should eq 2_i64
    mul_arg.operator.should eq "*"
    mul_arg.right.not_nil!.as(Drizzle::AST::IntegerLiteral).value.should eq 3_i64

    # Argument 3: 4 + 5
    add_arg = exp.arguments[2].as Drizzle::AST::InfixExpression
    add_arg.left.not_nil!.as(Drizzle::AST::IntegerLiteral).value.should eq 4_i64
    add_arg.operator.should eq "+"
    add_arg.right.not_nil!.as(Drizzle::AST::IntegerLiteral).value.should eq 5_i64
  end
end
