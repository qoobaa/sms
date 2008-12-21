require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

# states: draft, pending, delivered, deleted

# Message.new(:content => "Blah blah blah", :recipients => "I'm not sure yet").save_as_draft
# Message.draft.first.discard
# Message.create(:content => "Important content", :recipients => "+48123456789", :gateway => gateway)
# Message.pending.first.deliver
# Message.first.delete

describe Message do
  include MessageSpecHelper

  it "should have initial state pending" do
    message = new_valid_message
    message.aasm_current_state.should == :pending
  end

  it "should validate acceptance of numbers in gateway" do
    gateway = stub_model(Gateway)
    gateway.should_receive(:allow_number?).with("123").and_return(false)
    gateway.should_receive(:allow_number?).with("456").and_return(false)
    telephone_number1 = stub_model(TelephoneNumber, :number => "123")
    telephone_number2 = stub_model(TelephoneNumber, :number => "456")
    message = new_valid_message(:gateway => gateway)
    message.telephone_numbers << telephone_number1
    message.telephone_numbers << telephone_number2
    message.stub!(:associate_telephone_numbers) # do not touch the association
    message.should have_at_least(2).errors_on(:recipient)
  end
end

describe Message, "delivered" do
  include MessageSpecHelper

  it "should change state to delivered if given gateway returns true" do
    telephone_number1 = stub_model(TelephoneNumber, :valid? => true)
    telephone_number2 = stub_model(TelephoneNumber, :valid? => true)
    telephone_numbers = [telephone_number1, telephone_number2]
    content = "content"
    gateway = stub_model(Gateway, :allow_number? => true)
    gateway.should_receive(:deliver).with(telephone_numbers, content).and_return(true)
    message = new_valid_message(:gateway => gateway, :content => content)
    message.telephone_numbers = telephone_numbers
    message.stub!(:associate_telephone_numbers) # do not touch the association
    message.deliver!
    message.aasm_current_state.should == :delivered
  end

  it "should not change state to delivered if given gateway returns false" do
    telephone_number1 = stub_model(TelephoneNumber, :valid? => true)
    telephone_number2 = stub_model(TelephoneNumber, :valid? => true)
    telephone_numbers = [telephone_number1, telephone_number2]
    content = "content"
    gateway = stub_model(Gateway, :allow_number? => true)
    gateway.should_receive(:deliver).with(telephone_numbers, content).and_return(false)
    message = new_valid_message(:gateway => gateway, :content => content)
    message.telephone_numbers = telephone_numbers
    message.stub!(:associate_telephone_numbers) # do not touch the association
    message.deliver!
    message.aasm_current_state.should == :pending
  end
end

describe Message do
  include MessageSpecHelper

  it "should associate telephone numbers before validation" do
    user = stub_model(User)
    telephone_number1 = stub_model(TelephoneNumber)
    telephone_number2 = stub_model(TelephoneNumber)
    telephone_number3 = stub_model(TelephoneNumber)
    user.telephone_numbers.should_receive(:find_or_initialize_by_recipient).with("123").and_return(telephone_number1)
    user.telephone_numbers.should_receive(:find_or_initialize_by_recipient).with("456").and_return(telephone_number2)
    user.telephone_numbers.should_receive(:find_or_initialize_by_recipient).with("789").and_return(telephone_number3)
    message = new_valid_message(:recipients => "123", :user => user)
    message.valid? # execute callback
    message.recipients = "456, 789"
    message.valid? # execute callback
    message.telephone_numbers.should == [telephone_number2, telephone_number3]
  end
end

describe Message, "integration" do
  include MessageSpecHelper
  include UserSpecHelper

  it "should associate telephone numbers before validation" do
    user = build_valid_user
    telephone_number1 = user.telephone_numbers.create!(:number => "123")
    telephone_number2 = user.telephone_numbers.create!(:number => "456")
    telephone_number3 = user.telephone_numbers.create!(:number => "789")
    message = new_valid_message(:recipients => "123", :user => user)
    message.valid? # execute callback
    message.recipients = "456, 789"
    message.valid? # execute callback
    message.telephone_numbers.should == [telephone_number2, telephone_number3]
  end
end
