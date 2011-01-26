class ActsAsArchive
  module Adapters
    module Sinatra
      
      def self.included(klass)
        if klass.root
          ActsAsArchive.load_from_yaml(klass.root)
        end
      end
    end
  end
end