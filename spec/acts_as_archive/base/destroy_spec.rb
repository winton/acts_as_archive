require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe ActsAsArchive::Base::Destroy do
  
  before(:all) do
    establish_test_db
    Article.create_archive_table
    @connection = ActiveRecord::Base.connection
  end
  
  describe 'delete_all!' do
    
    before(:each) do
      @articles = []
      @connection.execute("TRUNCATE TABLE #{Article.table_name}")
      5.times do |x|
        @articles << Article.create(:title => "Title #{x}", :body => "Body #{x}")
      end
    end
    
    it "should really delete all records" do
      Article.delete_all!
      Article.count.should == 0
      Article::Archive.count.should == 0
    end
    
  end
  
  describe 'delete_all' do
    
    before(:each) do
      @articles = []
      5.times do |x|
        @articles << Article.create(:title => "Title #{x}", :body => "Body #{x}")
      end
    end
    
    describe 'with conditions' do
      
      before(:each) do
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
      
      before(:each) do
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
    
      before(:each) do
        @articles = []
        5.times do |x|
          @articles << Article.create(:title => "Title #{x}", :body => "Body #{x}")
        end
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