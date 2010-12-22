require 'spec_helper'

describe ActsAsArchive do
  
  before(:each) do
    [ 8, 0, 8 ].each { |v| $db.migrate(v) }
    
    @record = Record.create :belongs_to_id => BelongsTo.create.id
    
    HasOne.create :record_id => @record.id
    
    HasMany.create :record_id => @record.id
    HasMany.create :record_id => @record.id
    
    Record.first.has_many_throughs.create
    Record.first.has_many_throughs.create
    
    Record.first.create_has_one_through_through.create_has_one_through
    
    @lengths = {
      :record => 1,
      :belongs_to => 1,
      :has_one => 1,
      :has_many => 2,
      :has_many_through => 2,
      :has_many_through_through => 2,
      :has_one_through => 1,
      :has_one_through_through => 1
    }
    
    @zero_lengths = @lengths.inject({}) do |hash, (key, value)|
      hash[key] = 0
      hash
    end
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