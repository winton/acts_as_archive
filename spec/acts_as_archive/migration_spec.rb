require File.dirname(__FILE__) + '/../spec_helper'

describe ActsAsArchive::Migration do
  
  before(:each) do
    establish_test_db
    Article.create_archive_table
  end
  
  describe 'method_missing_with_archive' do
    
    it 'should migrate both tables up' do
      migrate_up
      (@new_article_columns - @old_article_columns).should == [ 'permalink' ]
      (@new_archive_columns - @old_archive_columns).should == [ 'permalink' ]
    end
    
    it 'should migrate both tables down' do
      migrate_up
      @old_article_columns = @new_article_columns
      @old_archive_columns = @new_archive_columns
      ActiveRecord::Migrator.migrate("#{SPEC}/db/migrate", 0)
      @new_article_columns = columns("articles")
      @new_archive_columns = columns("archived_articles")
      (@old_article_columns - @new_article_columns).should == [ 'permalink' ]
      (@old_archive_columns - @new_archive_columns).should == [ 'permalink' ]
    end
    
    it "should not touch the archive's deleted_at column" do
      connection.add_column(:articles, :deleted_at, :datetime)
      Article.reset_column_information
      migrate_up("migrate_2")
      (@old_article_columns - @new_article_columns).should == [ 'deleted_at' ]
      (@old_archive_columns - @new_archive_columns).should == []
    end
  end
end
