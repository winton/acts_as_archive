require 'spec_helper'

unless FrameworkFixture.framework
  describe ActsAsArchive do
  
    before(:each) do
      before_each
    end
  
    it "should create records" do
      should_create_records
    end
  
    %w(delete delete_all destroy destroy_all).each do |type|
      describe type do
        it "should move records to archive tables" do
          should_move_records_to_archive_tables(type)
        end
      
        it "should move records back to original tables" do
          should_move_records_back_to_original_tables(type)
        end
      end
    end
  end
end

if FrameworkFixture.framework
  describe "#{FrameworkFixture.framework} #{FrameworkFixture.exact_version}" do

    include Rack::Test::Methods

    def app
      FrameworkFixture.app.call
    end
    
    before(:each) do
      before_each true, false
    end
  
    it "should have a pulse" do
      get "/pulse"
      last_response.body.should == '1'
    end
    
    it "should create records" do
      get "/should_create_records_action"
      last_response.body.should == '1'
    end
  
    %w(delete delete_all destroy destroy_all).each do |type|
      describe type do
        it "should move records to archive tables" do
          get "/should_move_records_to_archive_tables_action", :type => type
          last_response.body.should == '1'
        end
      
        it "should move records back to original tables" do
          get "/should_move_records_back_to_original_tables_action", :type => type
          last_response.body.should == '1'
        end
      end
    end
  end
end