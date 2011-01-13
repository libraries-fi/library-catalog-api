class CreateDataFields < ActiveRecord::Migration
  def self.up
    create_table :data_fields do |t|
      t.string :tag
      t.string :ind1
      t.string :ind2
      t.integer :title_id
      t.string :code
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :data_fields
  end
end
