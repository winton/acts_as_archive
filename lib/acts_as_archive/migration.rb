module ActsAsArchive
  module Migration
    
    def self.included(base)
      base.send :alias_method, :method_missing_without_archive, :method_missing
      base.send :alias_method, :method_missing, :method_missing_with_archive
    end
    
    def method_missing_with_archive(method, *args)
      method_missing_without_questions(method, *args)
    end
  end
end
