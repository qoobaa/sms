module TelephoneNumberSpecHelper
  def valid_telephone_number_attributes
    user = stub_model(User, :default_country_code => "+48")
    { :user => user,
      :number => "1234567890" }
  end

  # returns new telephone_number with given attributes bypassing attr_accessible
  def new_telephone_number(attributes = {})
    telephone_number = TelephoneNumber.new(attributes)
    telephone_number.user = attributes[:user]
    telephone_number
  end

  # builds and returns new telephone_number with valid attributes
  def build_valid_telephone_number(attributes = {})
    telephone_number = new_telephone_number(valid_telephone_number_attributes.merge(attributes))
    telephone_number.user = valid_telephone_number_attributes.merge(attributes)[:user]
    telephone_number.save!
    telephone_number
  end
end
