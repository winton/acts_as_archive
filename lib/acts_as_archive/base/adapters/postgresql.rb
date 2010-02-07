module ActsAsArchive
  module Base
    module Adapters
      module PostgreSQL
        
        private

        def archive_table_indexed_columns
          index_query = <<-SQL
            SELECT c2.relname as index_name
            FROM pg_catalog.pg_class c,
              pg_catalog.pg_class c2,
              pg_catalog.pg_index i
            WHERE c.oid = (SELECT c.oid
              FROM pg_catalog.pg_class c
              WHERE c.relname ~ '^(archived_#{table_name})$')
            AND c.oid = i.indrelid
            AND i.indexrelid = c2.oid
          SQL
          
          index_query.gsub!(/\s+/, ' ').strip!
          indexes = connection.select_all(index_query).collect do |r|
            r["index_name"]
          end

          # HACK: reverse engineer the column name
          indexes.map do |index|
            index.split("_on_").last
          end
        end
      end
    end
  end
end