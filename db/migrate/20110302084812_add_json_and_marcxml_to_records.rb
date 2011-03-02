class AddJsonAndMarcxmlToRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :marcxml, :text
    add_column :records, :json, :text
  end

  def self.down
    remove_column :records, :json
    remove_column :records, :marcxml
  end
end
