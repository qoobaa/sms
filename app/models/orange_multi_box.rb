class OrangeMultiBox < Gateway
  validates_presence_of :login
  validates_presence_of :password, :if => :password_required?

  def amount
    Rails.cache.fetch("gateway#{id}.amount") do
      amount = nil
      Gateways::OrangeMultiBox.new(login, self.class.decrypt(crypted_password)) { |gateway| amount = gateway.amount }
      amount
    end
  end

  def validate
    errors.add_to_base "Can't log in with given username and password" unless login.blank? or password.blank? or Gateways::OrangeMultiBox.login(login, password)
  end

  def allow_number?(number)
    true
  end

  def deliver(telephone_numbers, content)
    Rails.cache.delete("gateway#{id}.amount")
    result = false
    Gateways::OrangeMultiBox.new(login, self.class.decrypt(crypted_password)) do |gateway|
      result = gateway.deliver(telephone_numbers.map(&:number).join(","), content) if gateway.amount >= telephone_numbers.size
    end
    result
  end
end
