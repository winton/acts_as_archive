ActsAsArchive
=============

Don't delete your records, move them to a different table.

Like <code>acts\_as\_paranoid</code>, but doesn't change all your SQL queries.

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

Models
------

Add <code>acts\_as\_archive</code> to your models:

<pre>
class Article < ActiveRecord::Base

  acts_as_archive
  
  # Or you can add custom archive table indexes
  acts_as_archive :indexes => [ :id, :deleted_at ]
end
</pre>

Run acts\_as\_archive
---------------------

Terminal:

<pre>
cd your_rails_app
acts_as_archive
</pre>

This command replicates your table's structure into <code>archived\_articles</code>
(as per the example), with an additional <code>deleted\_at</code> column.

Run again if you add more <code>:indexes</code>.

That's it!
----------

Use <code>destroy</code>, <code>delete</code>, and <code>delete_all</code> like you normally would.
Records are copied into the archive table before being destroyed.

What if my schema changes?
--------------------------

Any new migrations on your <code>acts\_as\_archive</code> table are automatically applied to the archive table.

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

If a <code>deleted\_at</code> column is present in your table, the plugin will attempt to move deleted
records to the archive table. The <code>deleted\_at</code> value is preserved.
