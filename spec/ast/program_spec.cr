require "../spec_helper"

describe Drizzle::AST::Program do
  it "correctly generates a string form for a program node" do
    # Generate the program node by hand since our parser skips expressions
    statements : Array(Drizzle::AST::Statement) = [
      Drizzle::AST::Let.new(
        Drizzle::Token.new(Drizzle::TokenType::LET, "let"),
        Drizzle::AST::TypedIdentifier.new(
          Drizzle::Token.new(Drizzle::TokenType::IDENTIFIER, "my_var"),
          "my_var",
          Drizzle::AST::Identifier.new(
            Drizzle::Token.new(Drizzle::TokenType::IDENTIFIER, "any"),
            "any",
          ),
        ),
        Drizzle::AST::Identifier.new(
          Drizzle::Token.new(Drizzle::TokenType::IDENTIFIER, "another_var"),
          "another_var",
        ),
      ),
      Drizzle::AST::Return.new(
        Drizzle::Token.new(Drizzle::TokenType::RETURN, "return"),
        Drizzle::AST::Identifier.new(
          Drizzle::Token.new(Drizzle::TokenType::IDENTIFIER, "my_var"),
          "my_var",
        ),
      ),
    ]
    program = Drizzle::AST::Program.new statements

    # Check that the string for this program node matches what we expect
    expected_string = "let my_var: any = another_var\nreturn my_var"
    program.to_s.should eq expected_string
  end
end
