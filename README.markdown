ActsAsArchive
=============

Don't delete your records, move them to a different table.

Like <code>acts\_as\_paranoid</code>, but doesn't mess with your SQL queries.

Install
-------

script/plugin:

<pre>
script/plugin install git://github.com/winton/acts_as_archive.git
</pre>

rubygems:

<pre>
# terminal
sudo gem install winton-acts_as_archive

# environment.rb
config.gem "winton-acts_as_archive", :lib => "acts_as_archive", :source => "http://gems.github.com"
</pre>

Update models
-------------

Add <code>acts\_as\_archive</code> to your models:

<pre>
class Article < ActiveRecord::Base
  acts_as_archive
end
</pre>

<a name="run_acts_as_archive"></a>

Run acts\_as\_archive
---------------------

Terminal:

<pre>
cd your_rails_app
acts_as_archive
</pre>

This command creates your archive tables (<code>archived_articles</code> as per the example).

Archive tables mirror your table's structure, but with an additional <code>deleted_at</code> column.

Run this command every time you add <code>acts\_as\_archive</code> to a new model.

That's it!
----------

Use <code>destroy</code>, <code>delete</code>, and <code>delete_all</code> like you normally would.

Records move into the archive table instead of being destroyed.

What if my schema changes?
--------------------------

Any new migrations on your table are automatically applied to the archive table.

Query the archive
-----------------

Add <code>::Archive</code> to your ActiveRecord class:

<pre>
Article::Archive.find(:first)
</pre>

Restore from the archive
------------------------

Use <code>restore\_all</code> to copy archived records back to your table:

<pre>
Article.restore_all([ 'id = ?', 1 ])
</pre>

Auto-migrate from acts\_as\_paranoid
------------------------------------

If you previously used <code>acts\_as\_paranoid</code>, running the <code>acts\_as\_archive</code>
command will automatically move your deleted records to the archive table
(see <a href="#run_acts_as_archive">_Run acts\_as\_archive_</a>).

Original <code>deleted_at</code> values are preserved.

Add indexes to the archive table
--------------------------------

To keep insertions fast, there are no indexes on your archive table by default.

If you are querying your archive a lot, you will want to add indexes:

<pre>
class Article < ActiveRecord::Base
  acts_as_archive :indexes => [ :id, :created_at, :deleted_at ]
end
</pre>

Run the <code>acts\_as\_archive</code> command any time you add new indexes
(see <a href="#run_acts_as_archive">_Run acts\_as\_archive_</a>).