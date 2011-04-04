class AddIndexForIsbnInRecords < ActiveRecord::Migration
  def self.up
    add_index :records, :isbn
  end

  def self.down
    remove_index :records, :isbn
  end
end
