class CreateMessagesTelephoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :messages_telephone_numbers, :id => false do |t|
      t.belongs_to :message, :telephone_number
    end
  end

  def self.down
    drop_table :messages_telephone_numbers
  end
end
