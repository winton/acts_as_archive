class HasOneThrough < ActiveRecord::Base
  
  belongs_to :has_one_through_through, :dependent => :delete
end