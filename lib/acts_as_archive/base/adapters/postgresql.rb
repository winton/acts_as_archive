module ActsAsArchive
  module Base
    module Adapters
      module PostgreSQL

        private

        def archive_table_indexed_columns
          # This query comes courtesy of cope360:
          # http://stackoverflow.com/questions/2204058/show-which-columns-an-index-is-on-in-postgresql/2213199#2213199
          index_query = <<-SQL
select
    t.relname as table_name,
    i.relname as index_name,
    a.attname as column_name
from
    pg_class t,
    pg_class i,
    pg_index ix,
    pg_attribute a
where
    t.oid = ix.indrelid
    and i.oid = ix.indexrelid
    and a.attrelid = t.oid
    and a.attnum = ANY(ix.indkey)
    and t.relkind = 'r'
    and t.relname = 'archived_#{table_name}'
order by
    t.relname,
    i.relname
SQL

          indexes = connection.select_all(index_query).collect do |r|
            r["column_name"]
          end
        end
      end
    end
  end
end
