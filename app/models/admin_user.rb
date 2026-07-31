class AdminUser < ApplicationRecord
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）
  include ::SelectableAttr::Base
  include ::DbConnectionCheck
  include CustomFieldDynamicAccessors

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :recoverable

  has_many :admin_user_sites, dependent: :destroy, autosave: true
  has_many :sites, :class_name => "::Site", :through => :admin_user_sites

  has_many :admin_user_custom_fields, dependent: :destroy, autosave: true, inverse_of: :admin_user
  has_many :custom_fields,
           -> { order('custom_fields.display_order ASC') },
           :through => :admin_user_custom_fields

  accepts_nested_attributes_for :admin_user_custom_fields, reject_if: :all_blank
  validates_associated :admin_user_custom_fields

  custom_field_dynamic_accessors!(
    association: :admin_user_custom_fields,
    data_source: :admin_user_custom_fields,
    custom_field_scope: lambda {
      if ::CustomField.respond_to?(:admin_users)
        ::CustomField.admin_users
      else
        ::CustomField.where(custom_field_type: "admin_user").order(:display_order)
      end
    }
  )

  belongs_to :role

  has_many :queries

  has_many :admin_user_attachments, dependent: :destroy
  accepts_nested_attributes_for :admin_user_attachments

  validates :role_id, presence: true

  validates :name, length: { maximum: 100 }, presence: true
  validates :email, length: { maximum: 100 }, presence: true


  selectable_attr :role_id do
    update_by(Role.select(:id, :role_name).all.to_sql, when: :everytime) if ::AdminUser.database_connected? and ActiveRecord::Base.connection.table_exists?('roles')
  end

  attr_accessor :selected_site

  attr_accessor :uuid
  attr_accessor :current_site_id

  validate :login_key_uniq

  def self.set_unique_key
    SecureRandom.hex
  end

  selectable_attr :status_div do
    entry 'before_apply', :before_apply, 'before_apply'
    entry 'applying', :applying, 'applying'
    entry 'accepted', :accepted, 'accepted'
    entry 'denied', :denied, 'denied'
  end

  scope :active, -> { where status_div: 'accepted'}

  scope :define_site, -> site_id {joins("join admin_user_sites on admin_user_sites.admin_user_id = admin_users.id").where(admin_user_sites: {site_id: site_id})}
  scope :user_prohabbits, ->(site_ids) { joins(:admin_user_sites).where("admin_user_sites.site_id in (?)", site_ids)}

  validates :site_ids, presence: true
  validates :name, presence: true

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    site_id = conditions.delete(:current_site_id) || conditions.delete(:site_id)

    condition_wheres = []
    condition_where_args = []
    if site_id
      condition_wheres << "admin_user_sites.site_id = ?"
      condition_where_args << site_id
    end

    pkeys = self.authentication_keys.dup.delete_if{|x| x == :current_site_id}
    pkeys.each do |k|
      arg = conditions.delete(k)
      condition_wheres << "admin_users.#{k} = ?"
      condition_where_args << arg
    end

    user = self.where(conditions).joins(:admin_user_sites).find_by(condition_wheres.join(" AND "), *condition_where_args)
    user.current_site_id = site_id if user

    user
  end

  def admin?
    self.role.role_short_name.downcase == 'admin'
  end

  def manager?
    self.role.role_short_name.downcase == 'manager'
  end

  def member?
    self.role.role_short_name.downcase == 'member'
  end

  def selected_site
    session = Thread.current[:request].try(:session)
    session[:active_site_id] if session
  end

  def selected_site=(site_id)
    session = Thread.current[:request].session
    session[:active_site_id] = site_id
  end

  def devise_will_save_change_to_email?
    false
  end

  def send_reset_password_instructions
    token = set_reset_password_token
    send_reset_password_instructions_notification(token)
    token
  end

  def send_reset_password_instructions_notification(token)
    mail_template = ::MailTemplate.where(template_name: "PASSWORD_RESET").for_site(self.current_site_id).first
    ::AdminUserMailer.password_reset(mail_template, self.current_site_id, self, token).deliver if mail_template.enable
  end

  private
  def login_key_uniq
    pkeys = self.class.authentication_keys.dup.delete_if{|x| x == :current_site_id}
    if self.current_site_id.present?
      users = ::AdminUserSite.joins(:admin_user).where("admin_user_sites.site_id = ?", self.current_site_id)
    else
      users = ::AdminUserSite.joins(:admin_user).where("admin_user_sites.site_id IN (?)", self.site_ids)
    end

    pkeys.each do |k|
      users = users.where("admin_users.#{k} = ?", self.send(k))
    end
    target_users = AdminUser.where("id IN (?)", users.map(&:id)).all
    if target_users.size > 1
      self.errors.add(pkeys.first, I18n.t(:"activerecord.errors.messages.taken"))
    end
  end
end
