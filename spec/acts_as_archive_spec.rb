require 'spec_helper'

unless FrameworkFixture.framework
  describe ActsAsArchive do
  
    before(:each) do
      [ 8, 0, 8 ].each { |v| $db.migrate(v) }
      @record, @lengths, @zero_lengths = setup_records
    end
  
    it "should create records" do
      original, archive = all_records
      verify_lengths original, @lengths
      verify_attributes original
    end
  
    %w(delete delete_all destroy destroy_all).each do |type|
      describe type do
        it "should move records to archive tables" do
          case type
          when 'delete', 'destroy'
            @record.send type
          when 'delete_all', 'destroy_all'
            Record.send type
          end
        
          original, archive = all_records
        
          case type
          when 'delete', 'delete_all'
            archive[:record].length.should == 1
            original[:record].length.should == 0
          
            verify_lengths archive, @zero_lengths, :exclude => [ :record ]
            verify_lengths original, @lengths, :exclude => [ :record ]
          
            verify_attributes archive, :only => [ :record ]
          
          when 'destroy', 'destroy_all'
            verify_lengths archive, @lengths
            verify_lengths original, @zero_lengths
          
            verify_attributes archive
          end
        end
      
        it "should move records back to original tables" do
          @record.destroy
          Record::Archive.first.destroy
        
          original, archive = all_records
        
          verify_lengths original, @lengths
          verify_lengths archive, @zero_lengths
        
          verify_attributes original
        end
      end
    end
  end
end

if FrameworkFixture.rails == '<3'
  describe 'Rails 2' do

    include Rack::Test::Methods

    def app
      FrameworkFixture.app.call
    end
  
    it "should have a pulse" do
      get "/pulse"
      last_response.body.should == '1'
    end
  end
end