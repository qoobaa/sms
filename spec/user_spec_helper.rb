module UserSpecHelper
  def valid_user_attributes
    { :login => "Login",
      :name => "",
      :email => "email@domain.com",
      :password => "secret",
      :password_confirmation => "secret",
      :default_country_code => "+48",
      :time_zone => "Warsaw" }
  end

  # returns new user with given attributes bypassing attr_accessible
  def new_user(attributes = {})
    user = User.new(attributes)
    user
  end

  # builds and returns new user with valid attributes
  def build_valid_user(attributes = {})
    user = new_user(valid_user_attributes.merge(attributes))
    user.save!
    user
  end
end
