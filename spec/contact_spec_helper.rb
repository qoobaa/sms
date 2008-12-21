module ContactSpecHelper
  def valid_contact_attributes
    user = stub_model(User, :new_record? => false)
    { :user => user,
      :name => "name" }
  end

  # returns new contact with given attributes bypassing attr_accessible
  def new_contact(attributes = {})
    contact = Contact.new(attributes)
    contact
  end

  # builds and returns new contact with valid attributes
  def build_valid_contact(attributes = {})
    contact = new_contact(valid_contact_attributes.merge(attributes))
    contact.save!
    contact
  end
end
