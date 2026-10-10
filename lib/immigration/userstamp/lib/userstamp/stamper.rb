module Ddb #:nodoc:
  module Userstamp
    module Stamper
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
        base.send :include, InstanceMethods
      end

      module ClassMethods
        def model_stamper
          # don't allow multiple calls
          return if self.included_modules.include?(Ddb::Userstamp::Stamper::InstanceMethods)
          # send(:extend, Ddb::Userstamp::Stamper::InstanceMethods)
        end

        # リクエスト（スレッド）単位で記録者を設定する。
        # Thread.current はスレッドが再利用されるため、必ず reset_stamper と対で使うこと。
        def stamper=(object)
          object_stamper = if object.is_a?(ActiveRecord::Base)
            object.send("#{object.class.primary_key}".to_sym)
          else
            object
          end

          Thread.current[stamper_key] = object_stamper
        end

        def stamper
          Thread.current[stamper_key]
        end

        def reset_stamper
          Thread.current[stamper_key] = nil
        end

        private
          def stamper_key
            "#{self.to_s.downcase}_stamper"
          end
      end

      module InstanceMethods
        def stamper=(object)
          self.class.stamper = object
        end

        def stamper
          self.class.stamper
        end

        def reset_stamper
          self.class.reset_stamper
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, Ddb::Userstamp::Stamper) if defined?(ActiveRecord)
