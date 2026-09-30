module DbConnectionCheck

  def self.included(mod)
    mod.extend(ClassMethods)
  end

  module ClassMethods
    
    def database_connected?
      result = true
      begin
        ActiveRecord::Base.connection
      rescue
        result = false
      end
      result
    end

  end
end
