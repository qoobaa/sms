class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.text :description
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
