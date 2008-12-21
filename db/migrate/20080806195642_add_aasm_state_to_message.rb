class AddAasmStateToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :aasm_state, :string
  end

  def self.down
    remove_column :messages, :aasm_state
  end
end
