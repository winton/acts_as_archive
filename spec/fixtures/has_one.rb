class HasOne < ActiveRecord::Base
  
  belongs_to :record, :dependent => :delete
end