require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::PrefixExpression do
  it "correctly parses and generates the correct nodes for the input" do
    tests = [
      [
        # Input
        "not 5",
        # Operator
        "not",
        # Value
        5_i64,
      ],
      [
        # Input
        "-15",
        # Operator
        "-",
        # Value
        15_i64,
      ],
    ]

    # For each test, parse the input and check the created nodes against what's expected
    tests.each do |test|
      input, operator, value = test
      lexer = Drizzle::Lexer.new input.to_s
      parser = Drizzle::Parser.new lexer
      program = parser.parse_program
      check_parser_errors parser

      program.statements.size.should eq 1
      stmnt = program.statements[0].as(Drizzle::AST::ExpressionStatement)
      exp = stmnt.expression.as(Drizzle::AST::PrefixExpression)
      exp.operator.should eq operator
      test_integer_literal exp.right, value
    end
  end
end
