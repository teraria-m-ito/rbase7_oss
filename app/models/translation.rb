# i18n-active_record の Translation を管理画面向けに拡張する
class Translation < I18n::Backend::ActiveRecord::Translation
  validates :locale, presence: true
  validates :key, presence: true
  validates :key, uniqueness: { scope: :locale }

  after_commit :reload_i18n_backend

  def self.locale_options
    I18n.available_locales.map { |locale| [locale.to_s, locale.to_s] }
  end

  # サイト名を scope に保存するための選択肢 [表示名, 保存値]
  def self.scope_options(sites = Site.active)
    sites.map { |site| [site.site_name, site.site_name] }
  end

  # 管理画面用。is_proc 時の Kernel.eval を避け、保存値をそのまま返す
  def raw_value
    v = read_attribute(:value)
    case v
    when String, NilClass, TrueClass, FalseClass
      v
    else
      v.inspect
    end
  end

  alias_method :display_value, :raw_value

  private

  def reload_i18n_backend
    I18n.backend.reload! if I18n.backend.respond_to?(:reload!)
    ::Translations::SearchConditions.reset_yml_cache!
  end
end
