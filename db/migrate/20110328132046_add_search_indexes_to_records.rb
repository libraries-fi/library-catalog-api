class AddSearchIndexesToRecords < ActiveRecord::Migration
  def self.up
    execute "CREATE INDEX records_author_main_tindex ON records USING gin(to_tsvector('finnish', coalesce(records.author_main, '')));"
    execute "CREATE INDEX records_isbn_tindex ON records USING gin(to_tsvector('finnish', coalesce(records.isbn, '')));"
    execute "CREATE INDEX records_title_main_tindex ON records USING gin(to_tsvector('finnish', coalesce(records.title_main, '')));"
  end

  def self.down
    execute "DROP INDEX records_author_main_tindex;"
    execute "DROP INDEX records_isbn_tindex;"
    execute "DROP INDEX records_title_main_tindex;"
  end
end
