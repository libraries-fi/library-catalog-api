class RemoveHelmetIdFromDataFields < ActiveRecord::Migration
  def self.up
    remove_column :data_fields, :helmet_id
  end

  def self.down
  end
end
