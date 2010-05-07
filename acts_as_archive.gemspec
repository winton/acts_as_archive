# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_archive}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Winton Welsh"]
  s.date = %q{2010-05-07}
  s.default_executable = %q{acts_as_archive}
  s.email = %q{mail@wintoni.us}
  s.executables = ["acts_as_archive"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["bin", "bin/acts_as_archive", "init.rb", "lib", "lib/acts_as_archive", "lib/acts_as_archive/base", "lib/acts_as_archive/base/adapters", "lib/acts_as_archive/base/adapters/mysql.rb", "lib/acts_as_archive/base/adapters/postgresql.rb", "lib/acts_as_archive/base/destroy.rb", "lib/acts_as_archive/base/restore.rb", "lib/acts_as_archive/base/table.rb", "lib/acts_as_archive/base.rb", "lib/acts_as_archive/migration.rb", "lib/acts_as_archive.rb", "MIT-LICENSE", "rails", "rails/init.rb", "Rakefile", "README.markdown", "require.rb", "spec", "spec/acts_as_archive", "spec/acts_as_archive/base", "spec/acts_as_archive/base/destroy_spec.rb", "spec/acts_as_archive/base/restore_spec.rb", "spec/acts_as_archive/base/table_spec.rb", "spec/acts_as_archive/base_spec.rb", "spec/acts_as_archive/migration_spec.rb", "spec/db", "spec/db/config", "spec/db/config/database.mysql.yml", "spec/db/config/database.postgresql.yml", "spec/db/log", "spec/db/migrate", "spec/db/migrate/001_add_to_articles.rb", "spec/db/migrate_2", "spec/db/migrate_2/001_add_to_articles.rb", "spec/db/models", "spec/db/models/article.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/winton/acts_as_archive}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Don't delete your records, move them to a different table}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<require>, ["= 0.2.1"])
    else
      s.add_dependency(%q<require>, ["= 0.2.1"])
    end
  else
    s.add_dependency(%q<require>, ["= 0.2.1"])
  end
end
