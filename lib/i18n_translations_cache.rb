# 複数ワーカー間で translations のプロセス内キャッシュを揃える。
# Redis は使わず、DB の件数と最新更新時刻を合図にする。
module I18nTranslationsCache
  @mutex = Mutex.new
  @fingerprint = nil
  @backend_snapshots = {}
  @simple_form_cache = {}
  @t_cache = {}
  @han_cache = {}

  class << self
    def refresh_if_stale!
      @mutex.synchronize do
        current = db_fingerprint
        return if current.nil?

        if @fingerprint && current != @fingerprint
          clear_ar_snapshots!
          reload_backends!
        end
        @fingerprint = current
        restore_or_warm_snapshots!
      end
    end

    def bump!
      @mutex.synchronize do
        clear_ar_snapshots!
        reload_backends!
        @fingerprint = db_fingerprint
        restore_or_warm_snapshots!
      end
    end

    def restore_after_rails_reload!
      @mutex.synchronize { restore_or_warm_snapshots! }
    end

    def simple_form_cache
      @simple_form_cache
    end

    def t_cache
      @t_cache
    end

    def han_cache
      @han_cache
    end

    def db_fingerprint
      count, max_at = ::Translation.unscoped.pick(Arel.sql("COUNT(*)"), Arel.sql("MAX(updated_at)"))
      "#{count}:#{max_at}"
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
      nil
    end

    def reload_backends!
      I18n.backend.reload! if I18n.backend.respond_to?(:reload!)
      ::Translations::SearchConditions.reset_yml_cache!
    end

    def restore_or_warm_snapshots!
      chain_backends.each_with_index do |backend, i|
        restore_or_warm_backend(backend, snapshot_key(backend, i))
      end
    end

    def restore_or_warm_backend(backend, snap_key)
      return unless backend

      current = backend.instance_variable_get(:@translations)
      snapshot = @backend_snapshots[snap_key]
      initialized = backend.respond_to?(:initialized?) ? backend.initialized? : !current.nil?
      empty = current.nil? || current == {}

      if snapshot && snapshot != {} && (empty || !initialized)
        backend.instance_variable_set(:@translations, snapshot)
        backend.instance_variable_set(:@initialized, true)
      elsif initialized && current && current != {}
        @backend_snapshots[snap_key] = current
      elsif backend.respond_to?(:init_translations, true)
        backend.send(:init_translations)
        warmed = backend.instance_variable_get(:@translations)
        @backend_snapshots[snap_key] = warmed if warmed && warmed != {}
      end
    end

    def clear_ar_snapshots!
      chain_backends.each_with_index do |backend, i|
        next unless backend.is_a?(I18n::Backend::ActiveRecord)
        @backend_snapshots.delete(snapshot_key(backend, i))
      end
      @simple_form_cache = {}
      @t_cache = {}
      @han_cache = {}
    end

    def snapshot_key(backend, index)
      "#{backend.class.name}:#{index}"
    end

    def chain_backends
      backend = I18n.backend
      if backend.is_a?(I18n::Backend::Chain)
        backend.backends
      else
        [backend]
      end
    end
  end
end

# Simple Form の labels/placeholders は YAML 側のキーなので、DB バックエンドを経由しない。
module SkipSimpleFormArLookup
  def lookup(locale, key, scope = [], options = {})
    keys = ::I18n.normalize_keys(locale, key, scope, options[:separator])
    return nil if keys[1] == :simple_form
    super
  end
end

# I18n.reload! 後も同じキーの翻訳結果を使い回す。
module I18nTranslateCache
  def translate(key = nil, **options)
    if options[:throw] || options[:raise]
      return super
    end

    extra = options.except(:locale, :scope, :count, :default, :separator)
    return super unless extra.empty?

    default = options[:default]
    if default.is_a?(Proc) || (default.is_a?(Array) && default.any? { |d| d.is_a?(Proc) })
      return super
    end

    cache = I18nTranslationsCache.t_cache
    cache_key = [config.locale, options[:locale], key, options[:scope], options[:count], default]
    return cache[cache_key] if cache.key?(cache_key)

    cache[cache_key] = super
  end

  alias_method :t, :translate
end

module HumanAttributeNameCache
  def human_attribute_name(attribute, options = {})
    return super unless options.empty?

    cache = I18nTranslationsCache.han_cache
    key = [I18n.locale, name, attribute.to_s]
    return cache[key] if cache.key?(key)

    cache[key] = super
  end
end
