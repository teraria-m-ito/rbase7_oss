class AdminUserAttachment < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  belongs_to :admin_user, optional: true

  mount_uploader :document, DocumentUploader

  def to_jq_upload
    {
      "name" => document.filename,
      "size" => document.size,
      "url" => document.url,
      "delete_url" => "/admin_users/#{id}",
      "delete_type" => "DELETE" 
    }
  end
  
  def default_title
    self.title ||= File.basename(document.filename, '/*') if document
  end

end
