# -*- encoding: utf-8 -*-
root = File.expand_path('../', __FILE__)
lib = "#{root}/lib"
$:.unshift lib unless $:.include?(lib)
 
require 'acts_as_archive/gems'
ActsAsArchive::Gems.gemset ||= ENV['GEMSET'] || :default

Gem::Specification.new do |s|
  ActsAsArchive::Gems.gemspec.hash.each do |key, value|
    if key == 'name' && ActsAsArchive::Gems.gemset != :default
      s.name = "#{value}-#{ActsAsArchive::Gems.gemset}"
    elsif key == 'summary' && ActsAsArchive::Gems.gemset == :solo
      s.summary = value + " (no dependencies)"
    elsif !%w(dependencies development_dependencies).include?(key)
      s.send "#{key}=", value
    end
  end

  ActsAsArchive::Gems.dependencies.each do |g|
    s.add_dependency g.to_s, ActsAsArchive::Gems.versions[g]
  end
  
  ActsAsArchive::Gems.development_dependencies.each do |g|
    s.add_development_dependency g.to_s, ActsAsArchive::Gems.versions[g]
  end

  s.executables = `cd #{root} && git ls-files -- {bin}/*`.split("\n").collect { |f| File.basename(f) }
  s.files = `cd #{root} && git ls-files`.split("\n")
  s.require_paths = %w(lib)
  s.test_files = `cd #{root} && git ls-files -- {features,test,spec}/*`.split("\n")
end