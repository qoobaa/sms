require File.dirname(__FILE__) + "/../spec_helper.rb"

describe E164, "split number" do
  it "should return nil if parameter is not a number" do
    E164.split_number("not a number").should be_nil
  end

  it "should return nil if country code is invalid" do
    E164.split_number("+805109821").should be_nil
  end

  it "should return nil if number is too long" do
    E164.split_number("+1111111111111111")
  end

  it "should return splitted number if number is valid" do
    E164.split_number("+48123456789").should == ["+48", "123456789"]
  end

  it "should return number with default country code if given" do
    E164.split_number("123456789", "+48").should == ["+48", "123456789"]
  end

  it "should sanitize number before splitting" do
    E164.split_number("   (+ 48) (0) 22       44 - 55   66   ").should == ["+48", "022445566"]
  end
end
