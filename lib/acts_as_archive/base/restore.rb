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
          connection.execute(%{
            INSERT INTO #{table_name} (#{column_names.join(', ')})
              SELECT #{column_names.join(', ')}
              FROM archived_#{table_name}
              #{where}
          })
          if where.empty?
            connection.execute("TRUNCATE TABLE archived_#{table_name}")
          else
            connection.execute("DELETE FROM archived_#{table_name} #{where}")
          end
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
