require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe ActsAsArchive::Base::Destroy do
  
  before(:all) do
    establish_test_db
    Article.create_archive_table
  end
  
  describe 'delete_all!' do
    
    before(:all) do
      create_records
    end
    
    it "should really delete all records" do
      Article.delete_all!
      Article.count.should == 0
      Article::Archive.count.should == 0
    end
    
  end
  
  describe 'delete_all' do
    
    before(:all) do
      @articles = create_records
    end
    
    describe 'with conditions' do
      
      before(:all) do
        # Mini delete_all parameter test
        Article.delete_all [ 'id = ?', @articles[0].id ]
        Article.delete_all "id = #{@articles[1].id}"
      end
      
      it "should move some records to the archive table" do
        Article.count.should == 3
        Article::Archive.count.should == 2
      end
      
      it "should preserve record attributes" do
        2.times do |x|
          original = @articles[x]
          copy = Article::Archive.find(original.id)
          article_match?(original, copy)
        end
      end
    end
    
    describe 'without conditions' do
      
      before(:all) do
        Article.delete_all
      end
      
      it "should move all records to the archive table" do
        Article.count.should == 0
        Article::Archive.count.should == 5
      end
      
      it "should preserve record attributes" do
        5.times do |x|
          original = @articles[x]
          copy = Article::Archive.find(original.id)
          article_match?(original, copy)
        end
      end
    end
  end
  
  [ :destroy, :delete ].each do |d|
    
    describe d do
    
      before(:all) do
        @articles = create_records
        Article.find(@articles[0..1].collect(&:id)).each do |a|
          a.send(d)
        end
      end
    
      it "should move some records to the archive table" do
        Article.count.should == 3
        Article::Archive.count.should == 2
      end
    
      it "should preserve record attributes" do
        2.times do |x|
          original = @articles[x]
          copy = Article::Archive.find(original.id)
          article_match?(original, copy)
        end
      end
    end
  end
end