class DropIsbnIndexFromRecords < ActiveRecord::Migration
  def self.up
    execute "DROP INDEX records_isbn_tindex;"
  end

  def self.down
    execute "CREATE INDEX records_isbn_tindex ON records USING gin(to_tsvector('finnish', coalesce(records.isbn, '')));"
  end
end
