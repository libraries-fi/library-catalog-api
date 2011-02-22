class RenameTitleIdToRecordId < ActiveRecord::Migration
  def self.up
    rename_column :data_fields, :title_id, :record_id
  end

  def self.down
    rename_column :data_fields, :record_id, :title_id
  end
end