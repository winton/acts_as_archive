Gem::Specification.new do |s|
  s.name    = 'acts_as_archive'
  s.version = '0.1.0'
  s.date    = '2009-04-22'
  
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
    lib/acts_as_archive/base/restore.rb
    lib/acts_as_archive/base/table.rb
    lib/acts_as_archive/migration.rb
    rails/init.rb
    spec/acts_as_archive/base/destroy_spec.rb
    spec/acts_as_archive/base/restore_spec.rb
    spec/acts_as_archive/base/table_spec.rb
    spec/acts_as_archive/migration_spec.rb
    spec/db/config/database.yml.example
    spec/db/log/.gitignore
    spec/db/migrate/001_add_to_articles.rb
    spec/db/models/article.rb
    spec/spec.opts
    spec/spec_helper.rb
  ]
  # = MANIFEST =
end