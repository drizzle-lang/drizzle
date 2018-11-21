require "./spec_helper"

describe Drizzle::Parser do
  it "correctly parses input with different operators into groups" do
    tests = [
      # input, output
      ["-a * b", "((-a) * b)"],
      ["not -a", "(not(-a))"],
      ["a + b + c", "((a + b) + c)"],
      ["a + b - c", "((a + b) - c)"],
      ["a * b * c", "((a * b) * c)"],
      ["a * b / c", "((a * b) / c)"],
      ["a+b/c", "(a + (b / c))"],
      ["a + b * c + d / e - f", "(((a + (b * c)) + (d / e)) - f)"],
      ["3 + 4\n-5 * 5", "(3 + 4)\n((-5) * 5)"],
      ["5 > 4 == 3 < 4", "((5 > 4) == (3 < 4))"],
      ["5 < 4 != 3 > 4", "((5 < 4) != (3 > 4))"],
      ["3 + 4 * 5 == 3 * 1 + 4 * 5", "((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))"],
      # Added Booleans
      ["3 > 5 == false", "((3 > 5) == false)"],
      ["3 < 5 == true", "((3 < 5) == true)"],
      # Adding Grouped Expressions
      ["1 + (2 + 3) + 4", "((1 + (2 + 3)) + 4)"],
      ["(5 + 5) * 2", "((5 + 5) * 2)"],
      ["2 / (5 + 5)", "(2 / (5 + 5))"],
      ["-(5 + 5)", "(-(5 + 5))"],
      ["not (true == true)", "(not(true == true))"],
    ]

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
end
