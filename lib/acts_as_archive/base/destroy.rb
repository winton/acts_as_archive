module ActsAsArchive
  module Base
    module Destroy

      def self.included(base)
        unless base.included_modules.include?(InstanceMethods)
          base.class_eval do
            alias_method :destroy_without_callbacks!, :destroy_without_callbacks
            class <<self
              alias_method :delete_all!, :delete_all
            end
          end
          base.send :extend, ClassMethods
          base.send :include, InstanceMethods
        end
      end

      module ClassMethods
        def copy_to_archive(conditions, import=false)
          add_conditions!(where = '', conditions)
          insert_cols = column_names.clone
          select_cols = column_names.clone
          if insert_cols.include?('deleted_at')
            unless import
              select_cols[select_cols.index('deleted_at')] = "'#{Time.now.utc.to_s(:db)}'"
            end
          else
            insert_cols << 'deleted_at'
            select_cols << "'#{Time.now.utc.to_s(:db)}'"
          end

          insert_cols.map! { |col| connection.quote_column_name(col) }
          select_cols.map! { |col| col =~ /^\'/ ? col : connection.quote_column_name(col) }

          connection.execute(%{
            INSERT INTO archived_#{table_name} (#{insert_cols.join(', ')})
              SELECT #{select_cols.join(', ')}
              FROM #{table_name}
              #{where}
          })
          connection.execute("DELETE FROM #{table_name} #{where}")
        end
      
        def delete_all(conditions=nil)
          copy_to_archive(conditions)
        end
      end

      module InstanceMethods
        def destroy_without_callbacks
          unless new_record?
            self.class.copy_to_archive("#{self.class.primary_key} = #{id}")
          end
          @destroyed = true
          freeze
        end

        def destroy!
          transaction { destroy_with_callbacks! }
        end

        def destroy_with_callbacks!
          return false if callback(:before_destroy) == false
          result = destroy_without_callbacks!
          callback(:after_destroy)
          result
        end
      end
    end
  end
end
