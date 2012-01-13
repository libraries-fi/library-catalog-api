class AddIndexToItemBarcode < ActiveRecord::Migration
  def self.up
    add_index :items, :barcode, :unique => true
  end

  def self.down
    remove_index :items, :barcode
  end
end
