class HasMany < ActiveRecord::Base
  
  belongs_to :record, :dependent => :delete
  
  acts_as_archive
end