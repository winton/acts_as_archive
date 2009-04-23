module ActsAsArchive
  module Migration
    
    def self.included(base)
      unless base.included_modules.include?(InstanceMethods)
        base.send :extend, ClassMethods
        base.class_eval do
          class <<self
            alias_method :method_missing_without_archive, :method_missing
            alias_method :method_missing, :method_missing_with_archive
          end
        end
      end
    end
    
    module ClassMethods
      
      def method_missing_with_archive(method, *arguments, &block)
        args = Marshal.load(Marshal.dump(arguments))
        method_missing_without_archive(method, *arguments, &block)
        supported = [
          :add_column, :add_timestamps, :change_column,
          :change_column_default, :change_table,
          :drop_table, :remove_column, :remove_columns,
          :remove_timestamps, :rename_column, :rename_table
        ]
        if args.include?(:deleted_at) || args.include?('deleted_at')
          # Don't change the archive's deleted_at column
          return
        end
        if !args.empty? && supported.include?(method)
          connection = ActiveRecord::Base.connection
          args[0] = "archived_" + ActiveRecord::Migrator.proper_table_name(args[0])
          if method == :rename_table
            args[1] = "archived_" + args[1]
          end
          if connection.table_exists?(args[0])
            connection.send(method, *args, &block)
          end
        end
      end
    end
    
    module InstanceMethods
    end
  end
end
