module ActsAsArchive
  module Base
    module Table

      def self.included(base)
        unless base.included_modules.include?(InstanceMethods)
          base.send :extend, ClassMethods
          base.send :include, InstanceMethods

          if base.connection.class.to_s.include?('Mysql')
            base.send :extend, ActsAsArchive::Base::Adapters::MySQL
          elsif base.connection.class.to_s.include?('PostgreSQL')
            base.send :extend, ActsAsArchive::Base::Adapters::PostgreSQL
          else
            raise 'acts_as_archive does not support this database adapter'
          end
        end
      end

      module ClassMethods

        def archive_table_exists?
          connection.table_exists?("archived_#{table_name}")
        end

        def create_archive_table
          if table_exists? && !archive_table_exists?
            connection.execute(%{
              CREATE TABLE archived_#{table_name}
                #{"ENGINE=InnoDB" if connection.class.to_s.include?('Mysql')}
                AS SELECT * from #{table_name}
                WHERE false;
            })
            columns = connection.columns("archived_#{table_name}").collect(&:name)
            unless columns.include?('deleted_at')
              connection.add_column("archived_#{table_name}", :deleted_at, :datetime)
            end
          end
        end

        def create_archive_indexes
          if archive_table_exists?
            indexes = archive_table_indexed_columns

            (archive_indexes - indexes).each do |index|
              connection.add_index("archived_#{table_name}", index)
            end
            (indexes - archive_indexes).each do |index|
              connection.remove_index("archived_#{table_name}", index)
            end
          end
        end


        def migrate_from_acts_as_paranoid
          if column_names.include?('deleted_at')
            if table_exists? && archive_table_exists?
              condition = "deleted_at IS NOT NULL"
              if self.count_by_sql("SELECT COUNT(*) FROM #{table_name} WHERE #{condition}") > 0
                # Base::Destroy.copy_to_archive
                copy_to_archive(condition, true)
              end
            end
          end
        end

        private

        def archive_table_indexed_columns
          case connection.class.to_s
          when "ActiveRecord::ConnectionAdapters::MysqlAdapter"
            index_query = "SHOW INDEX FROM archived_#{table_name}"
            indexes = connection.select_all(index_query).collect do |r|
              r["Column_name"]
            end
          when "ActiveRecord::ConnectionAdapters::PostgreSQLAdapter"
            #postgresql is...slightly...more complicated
            index_query = <<EOS
SELECT c2.relname as index_name
FROM pg_catalog.pg_class c,
     pg_catalog.pg_class c2,
     pg_catalog.pg_index i
WHERE c.oid = (SELECT c.oid
               FROM pg_catalog.pg_class c
               WHERE c.relname ~ '^(archived_#{table_name})$')
AND c.oid = i.indrelid
AND i.indexrelid = c2.oid
EOS
            indexes = connection.select_all(index_query).collect do |r|
              r["index_name"]
            end

            # HACK: reverse engineer the column name
            # This sucks, but acts_as_archive only adds indexes on single columns anyway so it should work OK
            # and getting the columns indexed is INCREDIBLY complicated in PostgreSQL.
            indexes.map do |index|
              index.split("_on_").last
            end
          else
            raise "Unsupported Database"
          end
        end
      end

      module InstanceMethods
      end
    end
  end
end
