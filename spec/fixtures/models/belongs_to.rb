class BelongsTo < ActiveRecord::Base
  
  has_many :records, :dependent => :delete_all
  
  acts_as_archive
end