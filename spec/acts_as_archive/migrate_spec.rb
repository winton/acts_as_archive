require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe ActsAsArchive::Migrate do
  
  before(:all) do
    establish_test_db
    @connection = ActiveRecord::Base.connection
  end
  
  describe 'create_archive_table' do
    
    before(:all) do
      Article.create_archive_table
      @article_columns = @connection.columns("articles").collect(&:name)
      @archive_columns = @connection.columns("archived_articles").collect(&:name)
    end
    
    it "should create an archive table" do
      @connection.table_exists?("archived_articles").should == true
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
end