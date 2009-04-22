require File.dirname(__FILE__) + "/base/destroy"
require File.dirname(__FILE__) + "/base/find"
require File.dirname(__FILE__) + "/base/structure"

module ActsAsArchive
  module Base
    def self.included(base)
      base.extend ActMethods
    end
  
    module ActMethods
      def acts_as_archive
        include Destroy
        include Find
        include Structure
      
        self.create_archive_table unless $TESTING
      
        class_eval <<-end_eval
          class Archive < ::ActiveRecord::Base
            set_table_name "archived_#{self.table_name}"
            self.record_timestamps = false
          end
        end_eval
      end
    end
  end
end
