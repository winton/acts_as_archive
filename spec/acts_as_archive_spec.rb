require 'spec_helper'

unless FrameworkFixture.framework
  describe ActsAsArchive do
  
    before(:each) do
      before_each
    end
    
    it "should have valid schema" do
      should_have_valid_schema
    end
  
    it "should create records" do
      should_create_records
    end
    
    describe :migrate_from_acts_as_paranoid do
      it "should migrate record and preserve deleted_at" do
        should_migrate_record_and_preserve_deleted_at
      end
    end
    
    describe :restore_all do
      it "should emulate delete_all" do
        should_emulate_delete_all
      end
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
      
      describe "#{type}!" do
        it "should delete records without archiving" do
          should_delete_records_without_archiving(type)
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
    
    it "should have valid schema" do
      get "/should_have_valid_schema_action"
      last_response.body.should == '1'
    end
    
    it "should create records" do
      get "/should_create_records_action"
      last_response.body.should == '1'
    end
    
    describe :migrate_from_acts_as_paranoid do
      it "should migrate record and preserve deleted_at" do
        get "/should_migrate_record_and_preserve_deleted_at_action"
        last_response.body.should == '1'
      end
    end
    
    describe :restore_all do
      it "should emulate delete_all" do
        get "/should_emulate_delete_all_action"
        last_response.body.should == '1'
      end
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
      
      describe "#{type}!" do
        it "should delete records without archiving" do
          get "/should_delete_records_without_archiving_action", :type => type
          last_response.body.should == '1'
        end
      end
    end
  end
end