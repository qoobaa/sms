class VoipDiscount < Gateway
  validates_presence_of :login
  validates_presence_of :password, :if => :password_required?
  validates_length_of :password, :in => 6..20, :if => :password_required?
  validates_length_of :login, :in => 4..20

  def validate
    errors.add_to_base "Can't log in with given username and password" unless login.blank? or password.blank? or Gateways::VoipDiscount.login(login, password)
  end

  def amount
    Rails.cache.fetch("gateway#{id}.amount") do
      amount = nil
      Gateways::VoipDiscount.login(login, self.class.decrypt(crypted_password)) { |gateway| amount = gateway.amount }
      amount
    end
  end

  def allow_number?(number)
    true
  end

  def deliver(telephone_numbers, content)
    Rails.cache.delete("gateway#{id}.amount")
    result = false
    Gateways::VoipDiscount.login(login, self.class.decrypt(crypted_password)) do |gateway|
      result = gateway.deliver(sender_number, telephone_numbers.map(&:number).join(","), content)
    end
    result
  end
end
