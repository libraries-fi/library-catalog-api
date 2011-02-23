class RenameRecordFields < ActiveRecord::Migration
  def self.up
    rename_column :records, :author_fields, :author_main
    rename_column :records, :title_fields, :title_main
  end  

  def self.down
    rename_column :records, :title_main, :title_fields
    rename_column :records, :author_main, :author_fields
  end
end