class HasOneThroughThrough < ActiveRecord::Base
  
  belongs_to :record, :dependent => :delete
  has_one :has_one_through, :dependent => :delete
  
  acts_as_archive
end