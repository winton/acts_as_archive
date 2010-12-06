require File.dirname(__FILE__) + '/acts_as_archive/gems'

ActsAsArchive::Gems.require(:lib)

$:.unshift File.dirname(__FILE__) + '/acts_as_archive'

require 'base'
require 'base/adapters/mysql'
require 'base/adapters/postgresql'
require 'base/destroy'
require 'base/restore'
require 'base/table'
require 'migration'
require 'version'

module ActsAsArchive
  
  def self.update(*models)
    models.each do |klass|
      if klass.respond_to?(:acts_as_archive?) && klass.acts_as_archive?
        time = Benchmark.measure do
          klass.create_archive_table
          klass.migrate_from_acts_as_paranoid
          klass.create_archive_indexes
        end
        $stdout.puts "-- ActsAsArchive.update(#{models.join(', ')})"
        $stdout.puts "   -> #{"%.4fs" % time.real}"
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsArchive::Base)
ActiveRecord::Migration.send(:include, ActsAsArchive::Migration)