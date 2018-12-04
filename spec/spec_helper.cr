require "spec"
require "../src/drizzle/*"

# Helper function that ensures there are no parser errors.
#
# If there are, it will print them out
def check_parser_errors(parser : Drizzle::Parser)
  errors = parser.errors
  if errors.empty?
    return
  end

  puts
  errors.each do |err|
    puts err
  end

  errors.size.should eq 0
end
