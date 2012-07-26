class AddItemNoToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :item_no, :integer
  end

  def self.down
    remove_column :items, :item_no
  end
end
