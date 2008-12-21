require "base64"

class Gateway < ActiveRecord::Base
  validates_uniqueness_of :name, :scope => :user_id
  validates_presence_of :user, :name

  attr_accessor :password
  attr_accessible :name, :login, :password, :sender_number, :user

  belongs_to :user
  has_many :messages

  before_save :encrypt_password

  def allow_number?(number)
    false
  end

  def deliver(telephone_numbers, content)
    false
  end

  def can_be_destroyed?
    messages.blank?
  end

  def self.types
    %w(OrangeMultiBox VoipDiscount)
  end

  def self.types_for_select
    [ ["Orange Multi Box", "OrangeMultiBox"],
      ["Voip Discount", "VoipDiscount"] ]
  end

  def decrypted_password
    self.class.decrypt(crypted_password)
  end

  def self.decrypt(password)
    Base64.decode64(password)
  end

  def self.crypt(password)
    Base64.encode64(password)
  end

  protected

  def encrypt_password
    return if password.blank?
    self.crypted_password = self.class.crypt(password)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def self.per_page
    8
  end
end
