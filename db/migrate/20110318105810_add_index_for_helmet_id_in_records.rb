class AddIndexForHelmetIdInRecords < ActiveRecord::Migration
  def self.up
    add_index :records, :helmet_id, :unique => true
  end

  def self.down
    remove_index :records, :helmet_id
  end
end
