class AddHelmetIdToDataFields < ActiveRecord::Migration
  def self.up
    add_column :data_fields, :helmet_id, :string
  end

  def self.down
    remove_column :data_fields, :helmet_id
  end
end