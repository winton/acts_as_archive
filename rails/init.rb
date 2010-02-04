require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.rails_init!

ActiveRecord::Base.send(:include, ActsAsArchive::Base)
ActiveRecord::Migration.send(:include, ActsAsArchive::Migration)