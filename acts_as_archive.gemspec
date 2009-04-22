Gem::Specification.new do |s|
  s.name    = 'acts_as_archive'
  s.version = '0.1.0'
  s.date    = '2009-04-21'
  
  s.summary     = "Moves your deleted records to a different table"
  s.description = "Moves your deleted records to a different table"
  
  s.author   = 'Winton Welsh'
  s.email    = 'mail@wintoni.us'
  s.homepage = 'http://github.com/winton/'
  
  # = MANIFEST =
  s.files = %w[
    CHANGELOG.markdown
    MIT-LICENSE
    README.markdown
    Rakefile
    acts_as_archive.gemspec
    init.rb
    lib/acts_as_archive.rb
    lib/acts_as_archive/base.rb
    lib/acts_as_archive/base/destroy.rb
    lib/acts_as_archive/base/find.rb
    lib/acts_as_archive/base/structure.rb
    lib/acts_as_archive/migration.rb
    rails/init.rb
    spec/acts_as_archive/destroy_spec.rb
    spec/acts_as_archive/find_spec.rb
    spec/acts_as_archive/migrate_spec.rb
    spec/config/database.yml.example
    spec/log/.gitignore
    spec/models/article.rb
    spec/spec.opts
    spec/spec_helper.rb
  ]
  # = MANIFEST =
end