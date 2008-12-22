class Message < ActiveRecord::Base
  include AASM
  extend ActiveSupport::Memoizable

  aasm_state :pending
  aasm_state :delivered

  aasm_initial_state :pending

  aasm_event :deliver do
    transitions :to => :delivered, :from => :pending, :guard => lambda { |m| m.send(:ensure_delivered) }
  end

  belongs_to :user
  belongs_to :gateway
  has_and_belongs_to_many :telephone_numbers

  validates_presence_of :content, :user
  validates_presence_of :recipients, :gateway
  validates_length_of :content, :maximum => 640
  validate :acceptance_of_telephone_numbers

  before_validation :sanitize_recipients, :associate_telephone_numbers

  @@per_page = 8
  cattr_reader :per_page

  attr_accessible :recipients, :content, :deliver_at
  attr_accessor :recipients

  named_scope :awaiting, lambda { { :conditions => ["aasm_state = ? AND deliver_at < ?", "pending", Time.now.utc] } }

  protected

  def ensure_delivered
    return false unless valid?
    result = gateway.deliver(telephone_numbers, content)
    self.delivered_at = Time.now
    result
  end

  def sanitize_recipients
    # do the magic
    self.recipients = recipients.squeeze(" ").split(",").map(&:strip).delete_if(&:empty?).uniq.join(", ") if recipients
  end

  def acceptance_of_telephone_numbers
    if gateway
      telephone_numbers.each do |t|
        errors.add :recipient, "number #{t.number} is not allowed in chosen gateway" unless gateway.allow_number?(t.number)
      end
    end
  end

  def associate_telephone_numbers
    telephone_numbers.clear
    recipients.split(", ").each { |r| telephone_numbers << user.telephone_numbers.find_or_initialize_by_recipient(r) } if recipients
    telephone_numbers.uniq!
  end
end
