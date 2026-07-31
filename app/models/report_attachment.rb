class ReportAttachment < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  mount_uploader :document, DocumentUploader

  belongs_to :report, autosave: false, optional: true
  
  def to_jq_upload
    {
      "name" => document.filename,
      "size" => document.size,
      "url" => document.url,
      "delete_url" => "/reports/#{id}",
      "delete_type" => "DELETE" 
    }
  end
  
  def default_title
    self.title ||= File.basename(document.filename, '/*') if document
  end
end
