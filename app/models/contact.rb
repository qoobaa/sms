class Contact < ActiveRecord::Base
  belongs_to :user
  has_one :telephone_number

  validates_presence_of :user, :name, :number
  validates_uniqueness_of :name, :scope => :user_id

  before_validation :sanitize_name, :associate_telephone_number
  after_save :nullify_number

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

  protected

  def associate_telephone_number
    telephone_number = user.telephone_numbers.find_or_initialize_by_number(@number)
    self.telephone_number = telephone_number if self.telephone_number != telephone_number
  end

  def sanitize_name
    self.name.strip!
  end

  def nullify_number
    @number = nil
  end
end
