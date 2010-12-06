# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'acts_as_archive/gems'
require 'acts_as_archive/version'

Gem::Specification.new do |s|
  s.name = "acts_as_archive"
  s.version = ActsAsArchive::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Winton Welsh"]
  s.email = ["mail@wintoni.us"]
  s.homepage = "http://github.com/winton/acts_as_archive"
  s.summary = "Don't delete your records, move them to a different table"
  s.description = "Don't delete your records, move them to a different table"

  ActsAsArchive::Gems::TYPES[:gemspec].each do |g|
    s.add_dependency g.to_s, ActsAsArchive::Gems::VERSIONS[g]
  end
  
  ActsAsArchive::Gems::TYPES[:gemspec_dev].each do |g|
    s.add_development_dependency g.to_s, ActsAsArchive::Gems::VERSIONS[g]
  end

  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = Dir.glob("{bin}/*").collect { |f| File.basename(f) }
  s.require_path = 'lib'
end