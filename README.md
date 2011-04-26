ActsAsArchive
=============

Don't delete your records, move them to a different table.

Like `acts_as_paranoid`, but doesn't mess with your SQL queries.

Install
-------

    gem install acts_as_archive

### Rails 2

#### config/environment.rb

    config.gem 'acts_as_archive'

#### config/initializers/load_acts_as_archive.rb

    ActsAsArchive.load_from_yaml(Rails.root)

### Rails 3

#### Gemfile

    gem 'acts_as_archive'

### Sinatra

    require 'acts_as_archive'
    
    class Application < Sinatra::Base
      include ActsAsArchive::Adapters::Sinatra
    end

config/acts_as_archive.yml
----------------------------

Create `config/acts_as_archive.yml` to define the archive class and archive table for each of your models:

    Article:
      - class: Article::Archive
        table: archived_articles
    
It is expected that neither the archive class or archive table exist yet. `ActsAsArchive` will create these automatically.

Migrate
-------

    class CreateArchiveTables < ActiveRecord::Migration
      def self.up
        ActsAsArchive.load_from_yaml(Rails.root)
        ActsAsArchive.migrate
      end
    
      def self.down
      end
    end

Run `rake db:migrate`. 

That's it!
----------

Use `destroy`, `destroy_all`, `delete`, and `delete_all` like you normally would.

Records move into the archive table instead of being destroyed.

Automatically archive relationships
-----------------------------------

If your model's relationship has the `:dependent` option, and the relationship also uses `acts_as_archive`, that relationship will archive automatically.

What if my schema changes?
--------------------------

New migrations are automatically applied to the archive table.

No action is necessary on your part.

Query the archive
-----------------

Use the archive class you specified in the configuration:

    Article::Archive.first

Delete records without archiving
--------------------------------

Use any of the destroy methods, but add a bang (!):

    Article::Archive.first.destroy!
    Article.delete_all!([ "id in (?)", [ 1, 2, 3 ] ])

Restore from the archive
------------------------

Use any of the destroy/delete methods on the archived record to move it back to its original table:

    Article::Archive.first.destroy
    Article::Archive.delete_all([ "id in (?)", [ 1, 2, 3 ] ])

Any relationships that were automatically archived will be restored as well.

Magic columns
-------------

You will find an extra `deleted_at` datetime column on the archive table.

You may manually add a `restored_at` datetime column to the origin table if you wish to store restoration time as well.

Migrate from `acts_as_paranoid`
-------------------------------

Add this line to a migration, or run it via `script/console`:

    Article.migrate_from_acts_as_paranoid

This copies all records with non-null `deleted_at` values to the archive.

Running specs
-------------

There is a [wiki entry](https://github.com/winton/acts_as_archive/wiki/Running-Specs) that describes the development setup in-depth.