# -*- coding: utf-8 -*-
module SelectableAttr
  # module Base
    # def self.included(base)
    # end    
  # end

  class AttrEnum
    def update_with_model(entries)
      @entries = entries.dup
      @update_timing = :everytime
    end

    def update_with_plugins(model, method)
      @model_for_update = model
      @method_for_update = method
      @update_timing = :everytime
      self.extend(InstanceMethodsForPlugin) unless respond_to?(:update_entries)
    end

    module InstanceMethodsForPlugin
      def entries
        update_entries if must_be_updated?
        @entries
      end

      def must_be_updated?
        return false if @update_timing == :never
        return true if @update_timing == :everytime
      end

      def update_entries
        unless @original_entries
          updated_entries = @model_for_update.to_s.constantize.send(@method_for_update, self)
          if updated_entries
            @original_entries = @entries.dup
            @entries = updated_entries
          end
        end
      end
    end
  end
end
