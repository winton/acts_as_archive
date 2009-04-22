module ActsAsArchive
  module Base
    module Find

      def self.included(base)
        unless base.included_modules.include?(InstanceMethods)
          base.send :extend, ClassMethods
          base.send :include, InstanceMethods
        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end
    end
  end
end
