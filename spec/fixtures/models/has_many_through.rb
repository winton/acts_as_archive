class HasManyThrough < ActiveRecord::Base
  
  has_many :has_many_through_throughs, :dependent => :delete_all
  has_many :records, :dependent => :delete_all, :through => :has_many_through_throughs
  
  acts_as_archive
end