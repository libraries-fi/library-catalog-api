class AddAdditionalAuthorsToRecords < ActiveRecord::Migration
  def self.up
    add_column :records, :additional_authors, :text
  end

  def self.down
    remove_column :records, :additional_authors
  end
end
