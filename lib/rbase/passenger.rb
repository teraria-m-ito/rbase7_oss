module Rbase
  module Passenger
    module Extendable
      def self.included(mod)
        mod.extend(ClassMethods)
        mod.instance_eval do
        end
      end

      private
      def passenger_restart
        if Rails.env != "production"
          `pumactl restart`
        else
          FileUtils.touch('tmp/restart.txt') if Rails.env == "production"
        end
      end
      public

      module ClassMethods

      end
    end
  end
end
