class AddSearchIndexToAdditionalAuthors < ActiveRecord::Migration

  def self.up
    execute "CREATE INDEX records_additional_authors_tindex ON records USING gin(to_tsvector('simple', coalesce(records.additional_authors, '')));"
  end

  def self.down
    execute "DROP INDEX records_additional_authors_tindex;"
  end
end
