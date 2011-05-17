
class AddTableAuthors < ActiveRecord::Migration
  def self.up
    create_table :additional_authors do |t|
      t.text    :name
    end
    execute "CREATE INDEX additional_authors_name_tindex ON additional_authors USING gin(to_tsvector('finnish', coalesce(additional_authors.name, '')));"
    
    create_table :additional_authors_records, :id => false do |t|
      t.integer :record_id, :null => false
      t.integer :additional_author_id, :null => false
    end    
    add_index(:additional_authors_records, [:record_id, :additional_author_id], :unique => true, :name => 'records_authors')
  end

  def self.down
    drop_table :additional_authors
    drop_table :additional_authors_records
  end
end
