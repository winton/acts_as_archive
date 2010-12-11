require File.dirname(__FILE__) + '/acts_as_archive/gems'

ActsAsArchive::Gems.require(:lib)

$:.unshift File.dirname(__FILE__) + '/acts_as_archive'

require 'version'

module ActsAsArchive
  
  def self.migrate_from_acts_as_paranoid(klass)
    if respond_to?(:acts_as_archive?) && acts_as_archive?
      time = Benchmark.measure do
        if column_names.include?('deleted_at')
          if table_exists? && archive_table_exists?
            condition = "deleted_at IS NOT NULL"
            if self.count_by_sql("SELECT COUNT(*) FROM #{table_name} WHERE #{condition}") > 0
              self.move_to(
                Archive,
                :conditions => condition,
                :migrate => true
              )
            end
          end
        end
      end
      $stdout.puts "-- ActsAsArchive.update(#{models.join(', ')})"
      $stdout.puts "   -> #{"%.4fs" % time.real}"
    end
  end
  
  module Base
    def self.included(base)
      base.extend ActMethods
    end

    module ActMethods
      def acts_as_archive(options={})
      end
    end
  end
  
  module AbstractAdapter
    def self.included(base)
      unless base.included_modules.include?(InstanceMethods)
        base.send :extend, ClassMethods
        base.class_eval do
          class <<self
            unless method_defined?(:delete_sql_without_archive)
              alias_method :delete_sql_without_archive, :delete_sql
              alias_method :delete_sql, :delete_sql_with_archive
            end
          end
        end
      end
    end

    module ClassMethods
      def delete_sql_with_archive(sql, name = nil)
        delete_sql_without_archive(sql, name)
      end
    end
    
    module InstanceMethods
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsArchive::Base)
ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, ActsAsArchive::AbstractAdapter)