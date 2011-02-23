class AddFiledTypeToDataFields < ActiveRecord::Migration
  def self.up
    add_column :data_fields, :field_type, :string
  end

  def self.down
    remove_column :data_fields, :field_type
  end
end