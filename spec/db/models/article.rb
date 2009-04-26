class Article < ActiveRecord::Base
  acts_as_archive :indexes => [ :id, :deleted_at ]
end
