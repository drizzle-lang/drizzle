require "./spec_helper"

describe Drizzle::Parser do
  it "correctly parses input with different operators into groups" do
    tests = {
      # input, output
      {
        "-a * b",
        "((-a) * b)",
      },
      {
        "not -a",
        "(not(-a))",
      },
      {"a + b + c",
       "((a + b) + c)",
      },
      {"a + b - c",
       "((a + b) - c)",
      },
      {"a * b * c",
       "((a * b) * c)",
      },
      {"a * b / c",
       "((a * b) / c)",
      },
      {"a+b/c",
       "(a + (b / c))",
      },
      {"a + b * c + d / e - f",
       "(((a + (b * c)) + (d / e)) - f)",
      },
      {"3 + 4\n-5 * 5",
       "(3 + 4)\n((-5) * 5)",
      },
      {"5 > 4 == 3 < 4",
       "((5 > 4) == (3 < 4))",
      },
      {"5 < 4 != 3 > 4",
       "((5 < 4) != (3 > 4))"},
      {"3 + 4 * 5 == 3 * 1 + 4 * 5",
       "((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))",
      },
      # Added Booleans
      {"3 > 5 == false",
       "((3 > 5) == false)",
      },
      {"3 < 5 == true",
       "((3 < 5) == true)",
      },
      # Adding Grouped Expressions
      {"1 + (2 + 3) + 4",
       "((1 + (2 + 3)) + 4)",
      },
      {"(5 + 5) * 2",
       "((5 + 5) * 2)",
      },
      {"2 / (5 + 5)",
       "(2 / (5 + 5))",
      },
      {"-(5 + 5)",
       "(-(5 + 5))",
      },
      {"not (true == true)",
       "(not(true == true))",
      },
      # Adding Call Expressions
      {"a + add(b * c) + d",
       "((a + add((b * c))) + d)",
      },
      {"add(a, b, 1, 2 * 3, 4 + 5, add(6, 7 * 8))",
       "add(a, b, 1, (2 * 3), (4 + 5), add(6, (7 * 8)))",
      },
      {"add(a + b + c * d / f + g)",
       "add((((a + b) + ((c * d) / f)) + g))",
      },
      # Added Index Expressions
      {
        "a * [1, 2, 3, 4][b * c] * d",
        "((a * ([1, 2, 3, 4][(b * c)])) * d)",
      },
      {
        "add(a * b[2], b[1], 2 * [1, 2][1])",
        "add((a * (b[2])), (b[1]), (2 * ([1, 2][1])))",
      },
    }

    tests.each do |test|
      input, output = test
      lexer = Drizzle::Lexer.new input
      parser = Drizzle::Parser.new lexer
      program = parser.parse_program
      check_parser_errors parser

      result = program.to_s
      result.should eq output
    end
  end

  it "correctly parses strings" do
    input = "'hello, world'"
    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser
    statement = program.statements[0].as Drizzle::AST::ExpressionStatement
    string = statement.expression.as Drizzle::AST::StringLiteral
    string.value.should eq "hello, world"
  end

  it "correctly parses lists" do
    input = "[1, 2 * 2, 3 + 3]"
    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser
    statement = program.statements[0].as Drizzle::AST::ExpressionStatement
    list = statement.expression.as Drizzle::AST::ListLiteral
    list.elements.size.should eq 3
    list.to_s.should eq "[1, (2 * 2), (3 + 3)]"
  end

  it "correctly parses index expressions" do
    input = "lst[1 + 1]"
    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser
    statement = program.statements[0].as Drizzle::AST::ExpressionStatement
    exp = statement.expression.as Drizzle::AST::IndexExpression
    exp.to_s.should eq "(lst[(1 + 1)])"
  end
end
