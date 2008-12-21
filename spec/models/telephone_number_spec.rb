require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe TelephoneNumber, "new" do
  it "should not modify number if it is not valid" do
    user = stub_model(User)
    number = "John Doe"
    telephone_number = user.telephone_numbers.new(:number => number)
    telephone_number.save
    telephone_number.number.should == number
  end

  it "should sanitize number if it is valid" do
    user = stub_model(User, :default_country_code => "+48")
    telephone_number = user.telephone_numbers.create(:number => "(22) 555 12355")
    telephone_number.user = user
    telephone_number.save!
    telephone_number.number.should == "+482255512355"
  end
end
