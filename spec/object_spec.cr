require "./spec_helper"

describe Drizzle::Object do
  it "correctly hashes objects to numerical values" do
    hello1 = Drizzle::Object::StringObj.new "Hello World"
    hello2 = Drizzle::Object::StringObj.new "Hello World"
    diff1 = Drizzle::Object::StringObj.new "My name is freya"
    diff2 = Drizzle::Object::StringObj.new "My name is freya"

    # compare the hash keys of the objects
    hello1.hash.should eq hello2.hash
    diff1.hash.should eq diff2.hash
    hello1.hash.should_not eq diff1.hash
  end
end
