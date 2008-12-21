class AddDeliverAtToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :deliver_at, :datetime
  end

  def self.down
    remove_column :messages, :deliver_at
  end
end
