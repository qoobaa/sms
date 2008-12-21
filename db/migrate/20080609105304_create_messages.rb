class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :content
      t.belongs_to :gateway
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
