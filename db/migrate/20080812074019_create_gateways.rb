class CreateGateways < ActiveRecord::Migration
  def self.up
    create_table :gateways do |t|
      t.string :login, :crypted_password, :sender_number, :type, :name
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :gateways
  end
end
