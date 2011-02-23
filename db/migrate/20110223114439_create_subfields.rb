class CreateSubfields < ActiveRecord::Migration
  def self.up
    create_table :subfields do |t|
      t.string :value
      t.string :code
      t.integer :data_field_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subfields
  end
end
