require File.expand_path(File.dirname(__FILE__) + "/../lib/acts_as_archive")

ActiveRecord::Base.send(:include, ActsAsArchive::Base)
ActiveRecord::Migration.send(:include, ActsAsArchive::Migration)

module ActsAsArchive
  def self.update
    Object.subclasses_of(ActiveRecord::Base).each do |klass|
      if klass.respond_to?(:acts_as_archive?) && klass.acts_as_archive?
        klass.create_archive_table
        klass.migrate_from_acts_as_paranoid
        klass.create_archive_indexes
      end
    end
  end
end
