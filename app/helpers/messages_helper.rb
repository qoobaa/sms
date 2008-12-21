module MessagesHelper
  def link_to_telephone_number(telephone_number)
    if telephone_number.contact
      link_to(telephone_number.contact.name, contact_path(telephone_number.contact))
    else
      link_to(telephone_number.number, telephone_number_path(telephone_number))
    end
  end
end
