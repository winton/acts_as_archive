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
config.gem "winton-acts_as_archive"
</pre>

Models
------

Add <code>acts\_as\_archive</code> to your models:

<pre>
class Article < ActiveRecord::Base
  acts_as_archive
end
</pre>

That's it!
----------

Next time your Rails instance boots up, the plugin replicates your table's structure into
<code>archived\_articles</code> (as per the example), with an additional <code>deleted\_at</code> column.

Use <code>destroy</code>, <code>delete</code>, and <code>delete_all</code> like you normally would.
Records are copied into the archive table before being destroyed.

Archive Model
-------------

Run finds on the archive by adding <code>::Archive</code> to your model:

<pre>
Article::Archive.find(:first)
</pre>

Restore
-------

Use <code>restore\_all</code> to copy archive records back to your table:

<code>
Article.restore_all([ 'id = ?', 1 ])
</code>

Auto-migrate from acts\_as\_paranoid
------------------------------------

If a <code>deleted\_at</code> column is present in your table, the plugin will attempt to move deleted
records to the archive table.