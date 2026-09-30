class SystemSettingAttachment < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  mount_uploader :document, DocumentUploader

  # belongs_to :system_setting, optional: true
  belongs_to :system_setting, class_name: '::SystemSetting', foreign_key: 'system_setting_id', optional: true

  selectable_attr :type_div do
    entry 'corprate_stamp', :corprate_stamp, 'Corprate Stamp'
  end
  
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

  def is_image?
    [".jpg", ".jpeg", ".png", ".gif", ".tif"].include?(File.extname(self.document.path).to_s.downcase)
  end

  def save_attachment(uuid)
    if  self.new_record?
      attachment_document = self.document
      unless attachment_document.nil? && attachment_document.size != 0
        self.token = uuid
        self.filename = attachment_document.filename
        self.file_size = attachment_document.size

        self.save!
      end
    end
  end
end
