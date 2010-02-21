require "#{File.dirname(__FILE__)}/require"
Require.rakefile!

desc "Generate gemspec"
task :gemspec do
  File.open("#{Rake.original_dir}/acts_as_archive.gemspec", 'w') do |f|
    f.write(Require.gemspec.to_ruby)
  end
end