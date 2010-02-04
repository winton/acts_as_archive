require File.dirname(__FILE__) + "/base/destroy"
require File.dirname(__FILE__) + "/base/restore"
require File.dirname(__FILE__) + "/base/table"

module ActsAsArchive
  
  def self.update(*models)
    models.each do |klass|
      if klass.respond_to?(:acts_as_archive?) && klass.acts_as_archive?
        klass.create_archive_table
        klass.migrate_from_acts_as_paranoid
        klass.create_archive_indexes
        puts 'Success!'
      end
    end
  end
  
  module Base
    def self.included(base)
      base.extend ActMethods
    end
  
    module ActMethods
      def acts_as_archive(options={})
        class_eval <<-end_eval
          
          def self.acts_as_archive?
            self.to_s == #{self.to_s.inspect}
          end
          
          def self.archive_indexes
            #{Array(options[:indexes]).collect(&:to_s).inspect}
          end
          
          class Archive < ActiveRecord::Base
            self.record_timestamps = false
            self.table_name = "archived_#{self.table_name}"
          end
        end_eval
        include Destroy
        include Restore
        include Table
      end
    end
  end
end
