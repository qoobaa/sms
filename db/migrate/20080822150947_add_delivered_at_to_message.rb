class AddDeliveredAtToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :delivered_at, :datetime
  end

  def self.down
    remove_column :messages, :delivered_at
  end
end
