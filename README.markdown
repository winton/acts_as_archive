ActsAsArchive
=============

Don't delete your records, move them to a different table.

Like <code>acts\_as\_paranoid</code>, but doesn't mess with your SQL queries.

Install
-------

<pre>
sudo gem install acts_as_archive
</pre>

**environment.rb**:

<pre>
config.gem 'acts_as_archive'
</pre>

Update models
-------------

Add <code>acts\_as\_archive</code> to your models:

<pre>
class Article < ActiveRecord::Base
  acts_as_archive
end
</pre>

<a name="create_archive_tables"></a>

Create archive tables
---------------------

Add this line to a migration:

<pre>
ActsAsArchive.update Article, Comment
</pre>

Replace <code>Article, Comment</code> with your own models that use <code>acts_as_archive</code>.

Archive tables mirror your table's structure, but with an additional <code>deleted_at</code> column.

There is an [alternate way to create archive tables](http://wiki.github.com/winton/acts_as_archive/alternatives-to-migrations) if you don't like migrations.

That's it!
----------

Use <code>destroy</code>, <code>delete</code>, and <code>delete_all</code> like you normally would.

Records move into the archive table instead of being destroyed.

What if my schema changes?
--------------------------

New migrations are automatically applied to the archive table.

No action is necessary on your part.

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

If you previously used <code>acts\_as\_paranoid</code>, the <code>ActsAsArchive.update</code>
call will automatically move your deleted records to the archive table
(see <a href="#create_archive_tables">_Create archive tables_</a>).

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

Call <code>ActsAsArchive.update</code> upon adding new indexes
(see <a href="#create_archive_tables">_Create archive tables_</a>).

Delete records without archiving
--------------------------------

To destroy a record without archiving:

<pre>
article.destroy!
</pre>

To delete multiple records without archiving:

<pre>
Article.delete_all!(["id in (?)", [1,2,3]])
</pre>