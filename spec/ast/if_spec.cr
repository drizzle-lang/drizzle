require "./ast_spec_helper"
require "../spec_helper"

describe Drizzle::AST::IfStatement do
  it "can be made from a basic if statement on its own (if (x < y) { return x })" do
    input = "if (x < y) { return x }"

    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser

    # Ensure there is a single statement in the program
    program.statements.size.should eq 1
    # The first line should be an if statement
    if_stmnt = program.statements[0].as Drizzle::AST::IfStatement

    # Check that the condition is the correct infix expression
    cond = if_stmnt.condition.as Drizzle::AST::InfixExpression
    left = cond.left.not_nil!.as Drizzle::AST::Identifier
    left.value.should eq "x"
    cond.operator.should eq "<"
    right = cond.right.not_nil!.as Drizzle::AST::Identifier
    right.value.should eq "y"

    # Check that there is a single consequence, and that it is a return statement returning the identifier 'x'
    if_stmnt.consequence.statements.should eq 1
    ret = if_stmnt.consequence.statements[0].as Drizzle::AST::Return
    ret.value.as(Drizzle::AST::Identifier).value.should eq "x"
  end

  it "can handle alternatives (else) (if (x < y) { return x } else { return y })" do
    input = "if (x < y) { return x } else { return y }"

    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser

    # Ensure there is a single statement in the program
    program.statements.size.should eq 1
    # The first line should be an if statement
    if_stmnt = program.statements[0].as Drizzle::AST::IfStatement

    # Check that the condition is the correct infix expression
    cond = if_stmnt.condition.as Drizzle::AST::InfixExpression
    left = cond.left.not_nil!.as Drizzle::AST::Identifier
    left.value.should eq "x"
    cond.operator.should eq "<"
    right = cond.right.not_nil!.as Drizzle::AST::Identifier
    right.value.should eq "y"

    # Check that there is a single consequence, and that it is a return statement returning the identifier 'x'
    if_stmnt.consequence.statements.should eq 1
    ret = if_stmnt.consequence.statements[0].as Drizzle::AST::Return
    ret.value.as(Drizzle::AST::Identifier).value.should eq "x"

    # Check that there is a single alternative, and that it is a return statement returning the identifier 'y'
    if_stmnt.alternative.not_nil!.statements.should eq 1
    ret = if_stmnt.alternative.not_nil!.statements[0].as Drizzle::AST::Return
    ret.value.as(Drizzle::AST::Identifier).value.should eq "y"
  end

  it "can handle alternative conditions (elsif) (if (x < y) { return x } elsif (x > y) { return y } else { return z })" do
    input = "if (x < y) { return x } elsif (x > y) { return y } else { return z }"

    lexer = Drizzle::Lexer.new input
    parser = Drizzle::Parser.new lexer
    program = parser.parse_program
    check_parser_errors parser

    # Ensure there is a single statement in the program
    program.statements.size.should eq 1
    # The first line should be an if statement
    if_stmnt = program.statements[0].as Drizzle::AST::IfStatement

    # Check that the condition is the correct infix expression
    cond = if_stmnt.condition.as Drizzle::AST::InfixExpression
    left = cond.left.not_nil!.as Drizzle::AST::Identifier
    left.value.should eq "x"
    cond.operator.should eq "<"
    right = cond.right.not_nil!.as Drizzle::AST::Identifier
    right.value.should eq "y"

    # Check that there is a single consequence, and that it is a return statement returning the identifier 'x'
    if_stmnt.consequence.statements.should eq 1
    ret = if_stmnt.consequence.statements[0].as Drizzle::AST::Return
    ret.value.as(Drizzle::AST::Identifier).value.should eq "x"

    # Ensure there is an alternative condition with the correct test and result
    if_stmnt.alt_consequences.size.should eq 1
    alt_if_stmnt = if_stmnt.alt_consequences[0]
    cond = alt_if_stmnt.condition.as Drizzle::AST::InfixExpression
    left = cond.left.not_nil!.as Drizzle::AST::Identifier
    left.value.should eq "x"
    cond.operator.should eq ">"
    right = cond.right.not_nil!.as Drizzle::AST::Identifier
    right.value.should eq "y"
    alt_if_stmnt.consequence.statements.size.should eq 1
    ret = alt_if_stmnt.consequence.statements[0].as Drizzle::AST::Return
    ret.value.as(Drizzle::AST::Identifier).value.should eq "y"

    # Check that there is a single alternative, and that it is a return statement returning the identifier 'y'
    if_stmnt.alternative.not_nil!.statements.should eq 1
    ret = if_stmnt.alternative.not_nil!.statements[0].as Drizzle::AST::Return
    ret.value.as(Drizzle::AST::Identifier).value.should eq "z"
  end
end
