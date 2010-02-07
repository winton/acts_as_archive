module ActsAsArchive
  module Base
    module Adapters
      module MySQL
        
        private

        def archive_table_indexed_columns
          index_query = "SHOW INDEX FROM archived_#{table_name}"
          indexes = connection.select_all(index_query).collect do |r|
            r["Column_name"]
          end
        end
      end
    end
  end
end