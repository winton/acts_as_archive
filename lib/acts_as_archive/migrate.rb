module ActsAsArchive
  module Migrate

    def self.included(base)
      unless base.included_modules.include?(InstanceMethods)
        base.send :extend, ClassMethods
        base.send :include, InstanceMethods
      end
    end

    module ClassMethods
      
      # Creates the archive table and the extra deleted_at column.
      # This method is called when acts_as_archive is called.
      def create_archive_table
        unless connection.table_exists?("archived_#{table_name}")
          connection.execute("
            CREATE TABLE archived_#{table_name}
            ENGINE=InnoDB
              AS SELECT * from #{table_name}
              WHERE false;
          ")
        end
        columns = connection.columns("archived_#{table_name}").collect(&:name)
        unless columns.include?('deleted_at')
          connection.add_column("archived_#{table_name}", 'deleted_at', :datetime)
        end
      end
    end

    module InstanceMethods
    end
  end
end