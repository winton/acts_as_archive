require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe ActsAsArchive::Base::Table do

  before(:all) do
    establish_test_db
    Article.create_archive_table
  end

  describe 'create_archive_table' do

    before(:all) do
      @article_columns = connection.columns("articles").collect(&:name)
      @archive_columns = connection.columns("archived_articles").collect(&:name)
    end

    it "should create an archive table" do
      connection.table_exists?("archived_articles").should == true
    end

    it "should create an archive table with the same structure as the original table" do
      @article_columns.each do |col|
        @archive_columns.include?(col).should == true
      end
    end

    it "should add a deleted_at column to the archive table" do
      (@archive_columns - @article_columns).should == [ 'deleted_at' ]
    end
  end

  describe 'create_archive_indexes' do

    before(:all) do
      Article.create_archive_indexes
    end

    it "should create archive indexes" do
      indexes.to_set.should == [ "id", "deleted_at" ].to_set
    end

    it "should destroy archive indexes" do
      Article.class_eval { acts_as_archive }
      Article.create_archive_indexes
      indexes.should == []
    end
  end

  describe 'migrate_from_acts_as_paranoid' do

    before(:all) do
      connection.add_column(:articles, :deleted_at, :datetime)
      Article.reset_column_information
    end

    before(:each) do
      connection.execute("DELETE FROM #{Article::Archive.table_name}")
    end

    it "should move deleted records to the archive" do
      create_records(Article, :deleted_at => Time.now.utc)
      Article.migrate_from_acts_as_paranoid
      Article.count.should == 0
      Article::Archive.count.should == 5
    end

    it "should not move non-deleted records to the archive" do
      create_records
      Article.migrate_from_acts_as_paranoid
      Article.count.should == 5
      Article::Archive.count.should == 0
    end
  end
end
