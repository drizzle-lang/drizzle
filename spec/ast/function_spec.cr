require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::Function do
  it "properly generates the correct node structure for the function described in `examples/example5.drzl`" do
    file_name = "examples/example5.drzl"
    input_file = File.open file_name

    # Create a lexer and a parser, and parse the program from the file
    lexer = Drizzle::Lexer.new input_file
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser

    # Check that the program has only a single statement inside, which should be a function statement
    program.statements.size.should eq 1
    func = program.statements[0].as Drizzle::AST::Function

    # Check that details of the function node to ensure that it is as it should be

    # There should be 2 parameters, named x and y, both of type int
    func.params.size.should eq 2
    expected = {
      {"x", "int"},
      {"y", "int"},
    }
    expected.each.with_index do |values, i|
      name, datatype = values
      param = func.params[i]
      param.value.should eq name
      param.datatype.value.should eq datatype
    end

    # The body should contain 1 statement, which is an expression statement that is the infix expression `x + y`
    func.body.statements.size.should eq 1
    body = func.body.statements[0].as Drizzle::AST::ExpressionStatement
    exp = body.expression.as Drizzle::AST::InfixExpression
    left = exp.left.as Drizzle::AST::Identifier
    left.value.should eq "x"
    exp.operator.should eq "+"
    right = exp.right.as Drizzle::AST::Identifier
    right.value.should eq "y"
  end

  it "properly parses parameter lists" do
    tests = {
      {
        "def test() {}",
        [] of Array(String),
      },
      {
        "def test(x: int) {}",
        {
          ["x", "int"],
        },
      },
      {
        "def test(x: int, y: str, z: any) {}",
        {
          ["x", "int"],
          ["y", "str"],
          ["z", "any"],
        },
      },
    }

    tests.each do |test|
      input, expected = test
      lexer = Drizzle::Lexer.new input.to_s
      parser = Drizzle::Parser.new lexer
      program = parser.parse_program
      check_parser_errors parser

      # Get the function statement and check its parameter list to ensure it is correct
      program.statements.size.should eq 1
      func = program.statements[0].as Drizzle::AST::Function
      func.params.size.should eq expected.size
      expected.each.with_index do |values, i|
        name, datatype = values
        param = func.params[i]
        param.value.should eq name
        param.datatype.value.should eq datatype
      end
    end
  end
end
