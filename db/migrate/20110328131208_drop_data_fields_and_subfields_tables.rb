class DropDataFieldsAndSubfieldsTables < ActiveRecord::Migration
  def self.up
    drop_table :data_fields
    drop_table :subfields
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
