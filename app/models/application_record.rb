class ApplicationRecord < ActiveRecord::Base
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ApplicationConcern
  acts_as_paranoid
  primary_abstract_class

  attr_accessor :current_admin_user
  attr_accessor :current_site_id

  connects_to database: { writing: :primary, reading: :primary}

  def assign_attributes_except_save(new_attributes)
    ActiveRecord::Base.transaction do
      assign_attributes(new_attributes)
      raise ActiveRecord::Rollback
    end
  end
end
