class Contact < ActiveRecord::Base
  belongs_to :user
  has_one :telephone_number

  validates_presence_of :user, :name, :number, :telephone_number
  validates_uniqueness_of :name, :scope => :user_id
  validates_associated :telephone_number
  validate :telephone_number_association

  before_validation :associate_telephone_number

  attr_writer :number
  attr_accessible :name, :description, :telephone_number, :number

  @@per_page = 8
  cattr_reader :per_page

  def number
    @number ||= telephone_number ? telephone_number.number : ""
  end

  def self.find_all_by_name_like(name)
    find(:all, :conditions => ["name LIKE ?", "%#{name}%"], :limit => 10)
  end

  def name=(name)
    self[:name] = name.strip
  end

  protected

  def associate_telephone_number
    if @number
      telephone_number = user.telephone_numbers.find_or_initialize_by_number(@number)
      self.telephone_number = telephone_number if telephone_number.contact.blank?
    end
  end

  def telephone_number_association
    contact = user.telephone_numbers.find_or_initialize_by_number(@number).contact
    errors.add :number, "is being used by other contact" if contact and contact != self
  end
end
