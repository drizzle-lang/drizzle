require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::InfixExpression do
  it "correctly parses and generates the correct nodes for the input" do
    tests = [
      [
        # Input
        "5 + 5",
        # Left Expression Value
        5,
        # Operator
        "+",
        # Right Expression Value
        5,
      ],
      [
        # Input
        "5 - 5",
        # Left Expression Value
        5,
        # Operator
        "-",
        # Right Expression Value
        5,
      ],
      [
        # Input
        "5 * 5",
        # Left Expression Value
        5,
        # Operator
        "*",
        # Right Expression Value
        5,
      ],
      [
        # Input
        "5 / 5",
        # Left Expression Value
        5,
        # Operator
        "/",
        # Right Expression Value
        5,
      ],
      [
        # Input
        "5 > 5",
        # Left Expression Value
        5,
        # Operator
        ">",
        # Right Expression Value
        5,
      ],
      [
        # Input
        "5 < 5",
        # Left Expression Value
        5,
        # Operator
        "<",
        # Right Expression Value
        5,
      ],
      [
        # Input
        "5 == 5",
        # Left Expression Value
        5,
        # Operator
        "==",
        # Right Expression Value
        5,
      ],
      [
        # Input
        "5 != 5",
        # Left Expression Value
        5,
        # Operator
        "!=",
        # Right Expression Value
        5,
      ],
    ]

    # For each test, parse the input and check the created nodes against what's expected
    tests.each do |test|
      input, left_val, op, right_val = test
      lexer = Drizzle::Lexer.new input.to_s
      parser = Drizzle::Parser.new lexer
      program = parser.parse_program
      check_parser_errors parser

      program.statements.size.should eq 1
      stmnt = program.statements[0].as(Drizzle::AST::ExpressionStatement)
      exp = stmnt.expression.as(Drizzle::AST::InfixExpression)
      test_integer_literal exp.left, left_val.to_i64
      exp.operator.should eq op
      test_integer_literal exp.right, right_val.to_i64
    end
  end
end
