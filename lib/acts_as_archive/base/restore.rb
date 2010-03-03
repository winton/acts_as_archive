module ActsAsArchive
  module Base
    module Restore

      def self.included(base)
        unless base.included_modules.include?(InstanceMethods)
          base.send :extend, ClassMethods
          base.send :include, InstanceMethods
        end
      end

      module ClassMethods
        
        def copy_from_archive(conditions)
          add_conditions!(where = '', conditions)
          col_names = column_names - [ 'deleted_at' ]
          col_names.map! { |col| connection.quote_column_name(col) }
          connection.execute(%{
            INSERT INTO #{table_name} (#{col_names.join(', ')})
              SELECT #{col_names.join(', ')}
              FROM archived_#{table_name}
              #{where}
          })
          connection.execute("DELETE FROM archived_#{table_name} #{where}")
        end
        
        def restore_all(conditions=nil)
          copy_from_archive(conditions)
        end
      end

      module InstanceMethods
      end
    end
  end
end
