require File.dirname(__FILE__) + '/../spec_helper'

describe ActsAsArchive::Migration do
  
  before(:each) do
    establish_test_db
    Article.create_archive_table
    @connection = ActiveRecord::Base.connection
  end
  
  describe 'method_missing_with_archive' do
    
    before(:each) do
      @old_article_columns = @connection.columns("articles").collect(&:name)
      @old_archive_columns = @connection.columns("archived_articles").collect(&:name)
      ActiveRecord::Migrator.migrate("#{SPEC}/db/migrate")
      @new_article_columns = @connection.columns("articles").collect(&:name)
      @new_archive_columns = @connection.columns("archived_articles").collect(&:name)
    end
    
    it 'should migrate both tables up' do
      (@new_article_columns - @old_article_columns).should == [ 'permalink' ]
      (@new_archive_columns - @old_archive_columns).should == [ 'permalink' ]
    end
    
    it 'should migrate both tables down' do
      @old_article_columns = @new_article_columns
      @old_archive_columns = @new_archive_columns
      ActiveRecord::Migrator.migrate("#{SPEC}/db/migrate", 0)
      @new_article_columns = @connection.columns("articles").collect(&:name)
      @new_archive_columns = @connection.columns("archived_articles").collect(&:name)
      (@old_article_columns - @new_article_columns).should == [ 'permalink' ]
      (@old_archive_columns - @new_archive_columns).should == [ 'permalink' ]
    end
  end
end
