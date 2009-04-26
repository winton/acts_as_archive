require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe ActsAsArchive::Base do
  
  before(:all) do
    establish_test_db
  end
  
  describe 'acts_as_archive' do
    
    it "should add self.acts_as_archive? to the model" do
      Article.respond_to?(:acts_as_archive?).should == true
    end
    
    it "should add self.archive_indexes to the model" do
      Article.respond_to?(:archive_indexes).should == true
      Article.archive_indexes.should == [ 'id', 'deleted_at' ]
    end
    
    it "should add Archive class to the model" do
      defined?(Article::Archive).should == "constant"
    end
  end
end