module SpecHelper
  
  def all_records
    [
      {
        :record => Record.all,
        :belongs_to => BelongsTo.all,
        :has_one => HasOne.all,
        :has_many => HasMany.all,
        :has_many_through => HasManyThrough.all,
        :has_many_through_through => HasManyThroughThrough.all,
        :has_one_through => HasOneThrough.all,
        :has_one_through_through => HasOneThroughThrough.all
      },
      {
        :record => Record::Archive.all,
        :belongs_to => BelongsTo::Archive.all,
        :has_one => HasOne::Archive.all,
        :has_many => HasMany::Archive.all,
        :has_many_through => HasManyThrough::Archive.all,
        :has_many_through_through => HasManyThroughThrough::Archive.all,
        :has_one_through => HasOneThrough::Archive.all,
        :has_one_through_through => HasOneThroughThrough::Archive.all
      }
    ]
  end
  
  def before_each(migrate=true, setup=true)
    if migrate
      [ 8, 0, 8 ].each { |v| $db.migrate(v) }
    end
    if setup
      @record, @lengths, @zero_lengths = setup_records
    end
  end
  
  def setup_records
    record = Record.create :belongs_to_id => BelongsTo.create.id
    
    HasOne.create :record_id => record.id
    
    HasMany.create :record_id => record.id
    HasMany.create :record_id => record.id
    
    Record.first.has_many_throughs.create
    Record.first.has_many_throughs.create
    
    Record.first.create_has_one_through_through.create_has_one_through
    
    lengths = {
      :record => 1,
      :belongs_to => 1,
      :has_one => 1,
      :has_many => 2,
      :has_many_through => 2,
      :has_many_through_through => 2,
      :has_one_through => 1,
      :has_one_through_through => 1
    }
    
    zero_lengths = lengths.inject({}) do |hash, (key, value)|
      hash[key] = 0
      hash
    end
    
    [ record, lengths, zero_lengths ]
  end
  
  def should_create_records
    original, archive = all_records
    verify_lengths original, @lengths
    verify_attributes original
  end
  
  def should_move_records_back_to_original_tables
    @record.destroy
    Record::Archive.first.destroy
  
    original, archive = all_records
  
    verify_lengths original, @lengths
    verify_lengths archive, @zero_lengths
  
    verify_attributes original
  end
  
  def should_move_records_to_archive_tables(type)
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

  def verify_attributes(records, options={})
    options[:exclude] ||= []
    records.each do |key, value|
      if !options[:exclude].include?(key) && (!options[:only] || options[:only].include?(key))
        value.each do |record|
          record[:string].should == 'string'
          record[:integer].should == 1
          record[:created_at].is_a?(::Time).should == true
          record[:updated_at].is_a?(::Time).should == true
        end
      end
    end
  end

  def verify_lengths(records, lengths, options={})
    options[:exclude] ||= []
    records.each do |key, value|
      if !options[:exclude].include?(key) && (!options[:only] || options[:only].include?(key))
        value.length.should == lengths[key]
      end
    end
  end
end