require File.expand_path("#{File.dirname(__FILE__)}/../require")
Require.lib!

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