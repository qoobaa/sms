class User < ActiveRecord::Base
  acts_as_authentic

  has_many :telephone_numbers, :dependent => :delete_all do
    def find_or_initialize_by_recipient(recipient)
      find_by_contact_name(recipient.strip) or find_or_initialize_by_number(recipient)
    end

    def find_by_number(number)
      country_code, subscriber_number = E164.split_number(number, proxy_owner.default_country_code)
      find_by_country_code_and_subscriber_number(country_code, subscriber_number) if country_code and subscriber_number
    end

    def find_or_initialize_by_number(number)
      find_by_number(number) or new(:number => number)
    end

    def find_all_by_number_like(number)
      country_code, subscriber_number = E164.split_number(number, proxy_owner.default_country_code)
      find(:all, :conditions => ["country_code = ? AND subscriber_number LIKE ?", country_code, "%#{subscriber_number}%"], :limit => 10)
    end
  end

  has_many :contacts, :dependent => :delete_all
  has_many :messages, :dependent => :delete_all
  has_many :gateways, :dependent => :delete_all
  has_many :orange_multi_boxes
end
