require File.expand_path(File.dirname(__FILE__) + "/../lib/acts_as_archive")

ActiveRecord::Base.send(:include, ActsAsArchive::Base)
ActiveRecord::Migration.send(:include, ActsAsArchive::Migration)
