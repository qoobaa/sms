require File.dirname(__FILE__) + "/../spec_helper.rb"

describe Message do
  it { should belong_to(:user) }
  it { should belong_to(:gateway) }
  it { should have_and_belong_to_many(:telephone_numbers) }
  it { should protect_attributes(:aasm_state) }
  it { should allow_values_for(:recipients, "123456789", "123456789, 987654321") }
end
