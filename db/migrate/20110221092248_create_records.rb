class CreateRecords < ActiveRecord::Migration
  def self.up
    create_table :records do |t|
      t.text :author_fields
      t.string :isbn
      t.text :title_fields
      t.string :helmet_id

      t.timestamps
    end
  end

  def self.down
    drop_table :records
  end
end
