class CreateTelephoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :telephone_numbers do |t|
      t.string :country_code, :subscriber_number
      t.text :description
      t.belongs_to :contact, :user
      t.timestamps
    end
  end

  def self.down
    drop_table :telephone_numbers
  end
end
