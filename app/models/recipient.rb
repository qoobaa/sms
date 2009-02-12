class Recipient
  def self.find_by_user_and_name(user, query)
    telephone_numbers = user.telephone_numbers.find_all_by_number_like(query)
    contacts = user.contacts.find_all_by_name_like(query)
    telephone_numbers.map(&:number) + contacts.map(&:name)
  end
end
