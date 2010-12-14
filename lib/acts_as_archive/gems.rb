unless defined?(ActsAsArchive::Gems)
  
  require 'rubygems'
  
  class ActsAsArchive
    class Gems
    
      VERSIONS = {
        :activesupport => '=3.0.3',
        :active_wrapper => '=0.3.4',
        :also_migrate => '0.2.1',
        :mover => '0.3.3',
        :rake => '=0.8.7',
        :rspec => '=1.3.1'
      }
    
      TYPES = {
        :gemspec => [ :also_migrate, :mover ],
        :gemspec_dev => [ :active_wrapper, :rspec ],
        :lib => [ :also_migrate, :mover ],
        :rake => [ :rake, :rspec ],
        :spec => [ :activesupport, :active_wrapper, :rspec ],
        :spec_rake => [ :active_wrapper ]
      }
      
      class <<self
        
        def lockfile
          file = File.expand_path('../../../gems', __FILE__)
          unless File.exists?(file)
            File.open(file, 'w') do |f|
              Gem.loaded_specs.each do |key, value|
                f.puts "#{key} #{value.version.version}"
              end
            end
          end
        end
        
        def require(type=nil)
          (TYPES[type] || TYPES.values.flatten.compact).each do |name|
            gem name.to_s, VERSIONS[name]
          end
        end
      end
    end
  end
end