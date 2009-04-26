require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe ActsAsArchive::Base::Restore do
  
  before(:all) do
    establish_test_db
    Article.create_archive_table
  end
  
  describe 'restore_all' do
    
    before(:all) do
      @articles = create_records(Article::Archive)
    end
    
    describe 'with conditions' do
      
      before(:all) do
        # Mini restore parameter test
        Article.restore_all [ 'id = ?', @articles[0].id ]
        Article.restore_all "id = #{@articles[1].id}"
      end
      
      it "should move some records to the article table" do
        Article::Archive.count.should == 3
        Article.count.should == 2
      end
      
      it "should preserve record attributes" do
        2.times do |x|
          original = @articles[x]
          copy = Article.find(original.id)
          article_match?(original, copy)
        end
      end
    end
    
    describe 'without conditions' do
      
      before(:all) do
        Article.restore_all
      end
      
      it "should move all records to the archive table" do
        Article::Archive.count.should == 0
        Article.count.should == 5
      end
      
      it "should preserve record attributes" do
        5.times do |x|
          original = @articles[x]
          copy = Article.find(original.id)
          article_match?(original, copy)
        end
      end
    end
  end
end