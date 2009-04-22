require File.dirname(__FILE__) + "/base/destroy"
require File.dirname(__FILE__) + "/base/restore"
require File.dirname(__FILE__) + "/base/table"

module ActsAsArchive
  module Base
    def self.included(base)
      base.extend ActMethods
    end
  
    module ActMethods
      def acts_as_archive
        include Destroy
        include Restore
        include Table
        class_eval <<-end_eval
          class Archive < ActiveRecord::Base
            self.record_timestamps = false
            self.table_name = "archived_#{self.table_name}"
          end
        end_eval
      end
    end
  end
end
