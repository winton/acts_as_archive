ActsAsArchive
=============

Don't delete your records, move them to a different table.

Like <code>acts\_as\_paranoid</code>, but doesn't mess with your SQL queries.

Install
-------

<pre>
gem install acts_as_archive
</pre>

### Rails 2

#### config/environment.rb

<pre>
config.gem 'acts_as_archive'
</pre>

### Rails 3

#### Gemfile

<pre>
gem 'acts_as_archive'
</pre>

### Sinatra

<pre>
require 'acts_as_archive'
</pre>

Add to models
-------------

Add <code>acts\_as\_archive</code> to your models:

<pre>
class Article &lt; ActiveRecord::Base
  acts_as_archive
end
</pre>

Migrate
-------

Next time you run <code>rake db:migrate</code>, your archive tables will be created automatically.

That's it!
----------

Use <code>destroy</code>, <code>destroy\_all</code>, <code>delete</code>, and <code>delete_all</code> like you normally would.

Records move into the archive table instead of being destroyed.

What if my schema changes?
--------------------------

New migrations are automatically applied to the archive table.

No action is necessary on your part.

Query the archive
-----------------

Add <code>::Archive</code> to your ActiveRecord class:

<pre>
Article::Archive.first
</pre>

Delete records without archiving
--------------------------------

Use any of the destroy methods, but add a bang (!):

<pre>
Article::Archive.find(:first).destroy!
Article.delete_all!(["id in (?)", [1,2,3]])
</pre>

Restore from the archive
------------------------

Use any of the destroy/delete methods on the archived record to move it back to its original table:

<pre>
Article::Archive.first.destroy
Article::Archive.delete_all([ "id in (?)", [ 1, 2, 3 ] ])
</pre>

Magic columns
-------------

You will find an extra <code>deleted_at</code> datetime column on the archive table.

You may manually add a <code>restored_at</code> datetime column to the origin table if you wish to store restoration time as well.

Migrate from acts\_as\_paranoid
-------------------------------

Add this line to a migration, or run it via <code>script/console</code>:

<pre>
Article.migrate_from_acts_as_paranoid
</pre>

This copies all records with non-null <code>deleted_at</code> values to the archive.