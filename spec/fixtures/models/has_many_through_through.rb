class HasManyThroughThrough < ActiveRecord::Base
  
  belongs_to :record, :dependent => :delete
  belongs_to :has_many_through, :dependent => :delete
  
  acts_as_archive
end