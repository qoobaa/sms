class TelephoneNumber < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact
  has_and_belongs_to_many :messages

  validates_presence_of :user
  validates_presence_of :country_code, :message => "is blank or invalid", :if => :number_valid?
  validates_presence_of :subscriber_number, :if => :number_valid?
  validates_uniqueness_of :subscriber_number, :scope => [:country_code, :user_id], :message => "is already in database"

  attr_writer :number

  attr_accessible :number, :description

  before_validation :split_number
  after_save :nullify_number

  def number
    @number ||= joined_number
  end

  def to_s
    contact ? contact.name : number
  end

  def self.find_by_contact_name(name)
    contact = Contact.find_by_name(name)
    contact ? contact.telephone_number : nil
  end

  def validate
    errors.add :number, "is too long (maximum is 15 digits)" if sanitized_number.size > 16
    errors.add :number, "format is invalid or no contact with given name" unless sanitized_number =~ /\A(?:\+\d)?\d+\Z/
  end

  def can_be_destroyed?
    contact.nil? and messages.blank?
  end

  protected

  def number_valid?
    E164.is_a_number?(number)
  end

  def nullify_number
    @number = nil
  end

  def sanitized_number
    E164.sanitize_number(number)
  end

  def split_number
    self.country_code, self.subscriber_number = E164.split_number(number, user ? user.default_country_code : "")
  end

  def joined_number
    "#{country_code}#{subscriber_number}"
  end

  def self.per_page
    8
  end
end
