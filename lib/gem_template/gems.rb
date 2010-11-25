unless defined?(GemTemplate::Gems)
  
  require 'rubygems'
  
  module GemTemplate
    class Gems
    
      VERSIONS = {
        :active_wrapper => '=0.3.4',
        :rake => '=0.8.7',
        :rspec => '=1.3.1'
      }
    
      TYPES = {
        :gemspec => [],
        :gemspec_dev => [ :active_wrapper, :rspec ],
        :lib => [],
        :rake => [ :rake, :rspec ],
        :spec => [ :active_wrapper, :rspec ]
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