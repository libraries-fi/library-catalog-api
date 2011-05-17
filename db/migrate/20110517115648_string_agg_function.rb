class StringAggFunction < ActiveRecord::Migration

  # string_agg was introduced in postgresql 9.0
  # earlier versions need this definition for pg_search
  def self.up
    execute """
    CREATE OR REPLACE FUNCTION concat_delimited( TEXT, TEXT, TEXT ) RETURNS TEXT AS $$
      SELECT $1 || (CASE WHEN $1 = '' THEN '' ELSE $3 END) || $2;
      $$
      LANGUAGE SQL STRICT IMMUTABLE;

    CREATE AGGREGATE string_agg ( TEXT, TEXT ) (
      SFUNC = concat_delimited,
      STYPE = TEXT,
      INITCOND = ''
    );
    """
  end

  def self.down
    execute """
    DROP AGGREGATE string_agg(TEXT, TEXT);
    DROP FUNCTION concat_delimited(TEXT, TEXT, TEXT);
    """
  end
end
