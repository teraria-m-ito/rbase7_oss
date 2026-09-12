require "securerandom"

class SystemSetting < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base

  has_many :system_setting_sites, dependent: :destroy, autosave: true
  has_many :sites, :through => :system_setting_sites

  has_many :system_setting_attachments, class_name: '::SystemSettingAttachment', dependent: :destroy, autosave: true
  accepts_nested_attributes_for :system_setting_attachments

  attr_accessor :hint
  attr_accessor :uuid
  attr_accessor :existing_registered_setting

  validates :site_ids, presence: true
  validates :setting_category_div, presence: true
  validates :setting_div, presence: true
#  validates :setting_div, uniqueness: true

  validates :setting_value, presence: true, if: :check_setting_value

  validate :sites_validate

  def self.set_unique_key
    SecureRandom.hex
  end

  def sites_validate
    new_site_ids = Array(site_ids).map(&:to_i).reject(&:zero?)
    return if setting_div.blank? || new_site_ids.empty?

    SystemSetting.where(setting_div: self.setting_div).each do |system_setting|
      next if persisted? && system_setting.id == self.id

      existing_site_ids = Array(system_setting.site_ids).map(&:to_i).reject(&:zero?)
      next if (existing_site_ids & new_site_ids).empty?

      self.existing_registered_setting = system_setting
      errors.add(:base, I18n.t("activerecord.errors.messages.system_setting_already_registered"))
      break
    end
  end

  def check_setting_value
    ::SystemSetting.setting_div_entry_by_id(self.setting_div)[:input_type] != :file
  end

  selectable_attr :setting_category_div do
    entry 'C01', :application_setting, 'アプリケーション設定'
    entry 'S01', :sso_setting, 'SSO設定'
    update_with_plugins(:SystemSetting, :added_entries_for_setting_category_div)
  end

  def self.added_entries_for_setting_category_div(mod); end

  selectable_attr :setting_div do
    entry 'R001', :app_name    , 'アプリケーション名'    , required: true, category: :application_setting, input_type: :string, hint: <<-"END_OF_HINT" do
      ※ このアプリケーションの名称を指定します。
      入力例： 契約書類申請
      END_OF_HINT
    end
    entry 'R003', :system_mail_address    , 'システムメールアドレス'    , required: true, category: :application_setting, input_type: :string, hint: <<-"END_OF_HINT" do
      ※　送信元メールアドレスを指定します。
      入力例：
      admin@example.com
      END_OF_HINT
    end
    entry 'R004', :root_url    , 'ルートURL'    , required: true, category: :application_setting, input_type: :string, hint: <<-"END_OF_HINT" do
      ※　サービスのルートURLを登録します。
      入力例：
      https://xxxxxxxx.com
      END_OF_HINT
    end    
    entry 'R005', :available_register_user    , '会員登録可否'    , required: true, category: :application_setting, input_type: :boolean, hint: <<-"END_OF_HINT" do
      ※　会員登録の可否を登録します。
      可とした場合、ログイン前のトップページに会員登録のリンクを表示します。
      END_OF_HINT
    end
    entry 'R010', :logics    , '申請ロジック設定'    , required: true, category: :application_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※　申請を処理するロジックを指定します。
      　　この定義は、サイト１の設定がすべてのサイトに有効になります。
      入力例：
      issue_logic1|申請 ロジック1
      issue_logic2|申請 ロジック2
      END_OF_HINT
    end
    entry 'R020', :report_logics    , 'レポートロジック設定'    , required: true, category: :application_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※　申請で使用するレポートロジックを指定します。
      　　この定義は、サイト１の設定がすべてのサイトに有効になります。
      入力例：
      report1_logic|レポート1ロジック
      report2_logic|レポート2ロジック
      END_OF_HINT
    end
    entry 'R021', :delayed_job_timing    , 'ディレイドジョブ実行非同期設定'    , required: true, category: :application_setting, input_type: :boolean, reload: true, hint: <<-"END_OF_HINT" do
      ※　ディレイドジョブの実行タイミングを設定します。
      可とした場合、ディレイドジョブは非同期実行を行います。
      END_OF_HINT
    end

    entry 'R022', :force_sign_in    , '強制ログイン'    , required: true, category: :application_setting, input_type: :boolean, reload: true, hint: <<-"END_OF_HINT" do
      ※　強制ログインを設定します。
      可とした場合、未ログイン時は、ログインページに強制遷移します。
      END_OF_HINT
    end

    entry 'R023', :footer_signature    , 'フッターシグネイチャー'    , required: true, category: :application_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※　フッターシグネイチャーを設定します。
      未登録の場合、Powered by Teraria Labs,を表示します。
      END_OF_HINT
    end

    entry 'R024', :footer_copyright    , 'フッターコピーライト'    , required: true, category: :application_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※　フッターコピーライトを設定します。
      未登録の場合、Copyright &copy;  <%= Time.now.strftime("%Y") %> |  All rights reserved.</strong> All rights reserved.を表示します。
      END_OF_HINT
    end

    entry 'R025', :display_google_translate    , 'GOOGLE翻訳表示設定'    , required: true, category: :application_setting, input_type: :boolean, hint: <<-"END_OF_HINT" do
      ※ ONの場合、トップメニューにGOOGLE翻訳選択を表示します。
      END_OF_HINT
    end

    entry 'R026', :logo_path    , 'ロゴ画像のパス'    , required: true, category: :application_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※ ログ画像のパスを指定します。
      logo.png
      END_OF_HINT
    end


    entry 'S001', :sso_type    , 'SSOタイプ設定'    , required: true, category: :sso_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※　SSOタイプを設定します。
      　　この定義は、サイト１の設定がすべてのサイトに有効になります。
      saml2
      現在は、SAML2のみ許可しています。
      END_OF_HINT
    end
    entry 'S002', :sso_setting    , 'SSO接続情報'    , required: true, category: :sso_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※　SSO接続情報を設定します。
      　　この定義は、サイト１の設定がすべてのサイトに有効になります。
      現在は、SAML2のみ許可しています。
      END_OF_HINT
    end
    entry 'S003', :issue_mapping    , 'issuerマッピング設定'    , required: true, category: :sso_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※ issuerマッピング設定を設定します。
      　　この定義は、サイト１の設定がすべてのサイトに有効になります。
      入力例：
      issuerのURL|LMSのURL
      https：//shibboleth.example.com/realms/rbase|https：//moodle-dev.example.com
      END_OF_HINT
    end
    entry 'S004', :sso_enable    , 'SSO適用設定'    , required: true, category: :sso_setting, input_type: :boolean, reload: true, hint: <<-"END_OF_HINT" do
      ※ SSO適用設定を設定します。
      　　この定義は、サイト１の設定がすべてのサイトに有効になります。
      　　ONにした場合、SSO認証が有効になります。
      END_OF_HINT
    end

    entry 'S005', :force_sso_login    , '強制SSOログイン設定'    , required: true, category: :sso_setting, input_type: :boolean, hint: <<-"END_OF_HINT" do
      ※ 強制SSOログイン設定を設定します。
      　　この定義は、サイト１の設定がすべてのサイトに有効になります。
      SSOでのログインを強制する場合は、ONにします。
      END_OF_HINT
    end
    entry 'S006', :idp_finger_print    , 'IDPフィンガープリント'    , required: true, category: :sso_setting, input_type: :string, reload: true, hint: <<-"END_OF_HINT" do
      ※ IDPのフィンガープリントを設定します。
      この設定の登録が無い場合は、サーバソースのconfig/saml2/server.crtの内容を適用します。
      この設定は、idp metadataのX509証明書に対して、
      -----BEGIN CERTIFICATE-----
      X509の証明書のテキスト（MII．．)
      ----END CERTIFICATE-----
      をidp.pemに保存し、
      openssl x509 -in  ./idp.pem -noout -fingerprint -sha256
      の実行結果から：を削除した文字列を指定する。
      END_OF_HINT
    end
    entry 'S007', :require_sso_logout    , 'SSOログアウト設定'    , required: true, category: :sso_setting, input_type: :boolean, hint: <<-"END_OF_HINT" do
      ※  ログアウト時にSSO側もログアウトします。
      END_OF_HINT
    end
    update_with_plugins(:SystemSetting, :added_entries_for_setting_div)
  end

  def self.added_entries_for_setting_div(mod); end

  selectable_attr :setting_storage do
    ::SystemSetting.all.each do |system_setting|
      system_setting.site_ids.each do |site_id|
        category_div = SystemSetting.setting_category_div_key_by_id(system_setting.setting_category_div)
        s = SystemSetting.setting_div_enum.select{|x| x.id == system_setting.setting_div and x[:category] == category_div}.first
        if s
          entry "#{site_id}/#{system_setting.setting_category_div}/#{system_setting.setting_div}", "#{system_setting.setting_category_div}/#{system_setting.setting_div}", system_setting.setting_value, input_type: s[:input_type]
        end
      end
    end
  end

  def self.[](setting_div_key, site_id=nil)
    get_setting(setting_div_key, site_id)
  end
  
  def self.get_setting(setting_div_key, site_id)
    site_id = Site.first.try(:id) if site_id.blank?
    seting_div_entry = setting_div_entry_by_key(setting_div_key)
    raise ArgumentError, "Unknown setting_div_key: #{setting_div_key.inspect}" if seting_div_entry.null?
    raise ArgumentError, "No site_id" if site_id.blank?

    if seting_div_entry[:input_type] == :file
      setting = self.joins(:system_setting_sites).where("system_setting_sites.site_id = ?", site_id).where("system_settings.setting_div = ?", self.setting_div_id_by_key(setting_div_key)).first
      result = setting.system_setting_attachments[0].document.path
    else
      category_div = SystemSetting.setting_category_div_id_by_key(seting_div_entry[:category])
      result = ::SystemSetting.setting_storage_enum["#{site_id}/#{category_div}/#{seting_div_entry.id}"].name
    end

    result
  end

  def self.bool_get_setting(setting_div_key, site_id)
    self.get_setting(setting_div_key, site_id) == "1"
  end
  
  def self.get_multivalue_setting(setting_div_key, entity_name, value_div_name, value_div, site_id)
    seting_div_entry = setting_div_entry_by_key(setting_div_key)
    raise ArgumentError, "Unknown setting_div_key: #{setting_div_key.inspect}" if seting_div_entry.null?
    raise ArgumentError, "No site_id" if site_id.blank?
    self.setting_div_id_by_key(setting_div_key)
    setting = self.joins(:system_setting_sites).where("system_setting_sites.site_id = ?", site_id).where("system_settings.setting_div = ?", self.setting_div_id_by_key(setting_div_key)).first

    unless entity_name.nil?
      enum_value = eval("#{entity_name.classify}.#{value_div_name}_enum")
      unless enum_value[value_div].id.to_s == value_div.to_s
        return nil
      end
    end
    setting.setting_value.split("\n").each do|line|
      if line.split("|").first == value_div.to_s
        return line.split("|").second
      end
    end
    return nil
  end
  
  def self.get_multivalue(setting_div_key, value_div, site_id)
    seting_div_entry = setting_div_entry_by_key(setting_div_key)
    raise ArgumentError, "Unknown setting_div_key: #{setting_div_key.inspect}" if seting_div_entry.null?
    raise ArgumentError, "No site_id" if site_id.blank?

    setting = self.joins(:system_setting_sites).where("system_setting_sites.site_id = ?", site_id).where("system_settings.setting_div = ?", self.setting_div_id_by_key(setting_div_key)).first

    setting.setting_value.split("\n").each do|line|
      if line.split("|").first == value_div.to_s
        return line.split("|").second.strip
      end
    end
    return nil
  end
  
  def self.get_multivalue_list(setting_div_key, site_id)
    seting_div_entry = setting_div_entry_by_key(setting_div_key)
    raise ArgumentError, "Unknown setting_div_key: #{setting_div_key.inspect}" if seting_div_entry.null?
    raise ArgumentError, "No site_id" if site_id.blank?

    setting = self.joins(:system_setting_sites).where("system_setting_sites.site_id = ?", site_id).where("system_settings.setting_div = ?", self.setting_div_id_by_key(setting_div_key)).first

    result = []
    setting.try(:setting_value).to_s.split("\n").each do|line|
      if line.include?("|")
        l = line.split("|")
        value_div = l.shift
        h = {value_div: value_div.strip}
        l.each_with_index do |ll, idx|
          if idx == 0
            h[:value] = ll.strip
          else
            h[:"value#{idx+1}"] = ll.strip
          end
        end
        result << h
      end
    end
    return result
  end
  
  def self.get_multivalue_reverse(setting_div_key, value_div, site_id)
    seting_div_entry = setting_div_entry_by_key(setting_div_key)
    raise ArgumentError, "Unknown setting_div_key: #{setting_div_key.inspect}" if seting_div_entry.null?
    raise ArgumentError, "No site_id" if site_id.blank?

    setting = self.joins(:system_setting_sites).where("system_setting_sites.site_id = ?", site_id).where("system_settings.setting_div = ?", self.setting_div_id_by_key(setting_div_key)).first

    setting.setting_value.split("\n").each do|line|
      if line.split("|").second == value_div.to_s
        return line.split("|").first.strip
      end
    end
    return nil
  end    
  
  def self.set_multivalue_setting(setting_div_key, entity_name, value_div_name, value_div, site_id, value)
    seting_div_entry = setting_div_entry_by_key(setting_div_key)
    raise ArgumentError, "Unknown setting_div_key: #{setting_div_key.inspect}" if seting_div_entry.null?
    raise ArgumentError, "No site_id" if site_id.blank?
    self.setting_div_id_by_key(setting_div_key)
    setting = self.joins(:system_setting_sites).where("system_setting_sites.site_id = ?", site_id).where("system_settings.setting_div = ?", self.setting_div_id_by_key(setting_div_key)).first

    unless entity_name.nil?
      enum_value = eval("#{entity_name.classify}.#{value_div_name}_enum")
      unless enum_value[value_div].id.to_s == value_div.to_s
        return nil
      end
    end
    lines = []
    setting.setting_value.split("\n").each do|line|
      if line.split("|").first == value_div.to_s
        line = "#{line.split("|").first}|#{value}"
      end
      lines << line
    end
    
    setting.setting_value = lines.join("\n")
    setting.save
  end
    
  def self.get_tax_rate(site_id, target_date)
    target_system_setting = self.get_setting(:tax_rate, site_id).gsub(/\r\n|\r|\n/, ",")
    return target_system_setting.split(",")[0].split("|")[0] if target_date.blank?
    target_date_format = false
    begin
      DateTime.strptime(target_date, '%Y/%m/%d')
    rescue
      target_date_format = true 
    end
    return target_system_setting.split(",")[0].split("|")[0] if target_date_format
    
    target_system_setting.split(",").each do |tax_rate_line|
      tax_rate_line = tax_rate_line.split("|")
      if tax_rate_line[1]
        if DateTime.strptime(tax_rate_line[1], '%Y/%m/%d') <= DateTime.strptime(target_date, '%Y/%m/%d')
          if tax_rate_line[2].blank?
            return tax_rate_line[0]
          elsif DateTime.strptime(tax_rate_line[2], '%Y/%m/%d') >= DateTime.strptime(target_date, '%Y/%m/%d')
            return tax_rate_line[0]
          end
        end
      end
    end
    return target_system_setting.split(",")[0].split("|")[0]
  end
  
  def input_type
    ::SystemSetting.setting_div_entry_by_id(self.setting_div)[:input_type]
  end

  # デプロイ時の汎用タスク
  def self.prepare_deployed
    puts "prepare_deployed...."
  end
end
