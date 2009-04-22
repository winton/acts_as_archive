require File.dirname(__FILE__) + "/acts_as_archive/activerecord/base/destroy"
require File.dirname(__FILE__) + "/acts_as_archive/activerecord/base/find"
require File.dirname(__FILE__) + "/acts_as_archive/activerecord/base/migrate"
require File.dirname(__FILE__) + "/acts_as_archive/activerecord/migration"

module ActsAsArchive
  def self.included(base)
    base.extend ActMethods
  end
  
  module ActMethods
    def acts_as_archive
      include ActiveRecord::Base::Destroy
      include ActiveRecord::Base::Find
      include ActiveRecord::Base::Migrate
      self.create_archive_table unless $TESTING
    end
  end
end