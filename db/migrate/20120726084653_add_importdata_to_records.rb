class AddImportdataToRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :importdata, :text
  end

  def self.down
    remove_column :records, :importdata
  end
end
