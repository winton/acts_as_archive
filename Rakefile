require 'rubygems'
require 'rake'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

GEM_NAME = 'acts_as_archive'
PKG_FILES = FileList['**/*']

spec = Gem::Specification.new do |s|
  s.author = "Winton Welsh"
  s.email = "mail@wintoni.us"
  s.executables << GEM_NAME
  s.extra_rdoc_files = [ "README.markdown" ]
  s.files = PKG_FILES.to_a
  s.homepage = "http://github.com/winton/#{GEM_NAME}"
  s.name = GEM_NAME
  s.platform = Gem::Platform::RUBY
  s.require_path = "lib"
  s.summary = "Don't delete your records, move them to a different table"
  s.version = "0.1.2"
end

desc "Package gem"
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install gem"
task :install do
  Rake::Task['gem'].invoke
  `sudo gem uninstall #{GEM_NAME} -x`
  `sudo gem install pkg/#{GEM_NAME}*.gem`
  `rm -Rf pkg`
end

desc "Generate gemspec"
task :gemspec do
  File.open("#{File.dirname(__FILE__)}/#{GEM_NAME}.gemspec", 'w') do |f|
    f.write(spec.to_ruby)
  end
end

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = FileList["spec/**/*_spec.rb"]
end