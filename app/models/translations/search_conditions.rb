module Translations
  class SearchConditions
    include ::Rbase::PluginModule::Extendable
    include ActiveModel::Model

    attr_accessor :locale
    attr_accessor :key
    attr_accessor :value
    attr_accessor :scope

    # キー・翻訳文は YAML / DB の双方を対象に検索し、同一キーは1行にまとめる
    def search
      return default_db_results if search_key.blank? && search_value.blank?

      candidates = {}

      # DB: キー条件に合うものを候補化（翻訳文は YAML 結合後に双方で判定）
      each_db_record do |record|
        next unless match_key?(record.key)

        candidates[locale_key(record.locale, record.key)] = SearchResult.from_db(record)
      end

      # YAML: キー条件に合うものを候補化／既存候補へ YAML 文言を付与
      self.class.yml_entries.each do |entry|
        next if locale.present? && entry.locale != locale.to_s
        next unless match_key?(entry.key)

        key_name = locale_key(entry.locale, entry.key)
        if candidates[key_name]
          candidates[key_name].merge_yml!(entry.yml_value)
        else
          candidates[key_name] = SearchResult.from_yml(
            locale: entry.locale,
            key: entry.key,
            value: entry.yml_value
          )
        end
      end

      # DBのみ候補に YAML 文言を補完
      yml_index = self.class.yml_entries_index
      results = candidates.values.each do |result|
        next if result.yml_value.present?

        yml_value = yml_index[locale_key(result.locale, result.key)]
        result.merge_yml!(yml_value) if yml_value
      end

      # 翻訳文は YAML・DB のどちらかに含まれていればヒット
      results = results.select { |result| result.match_value?(search_value) }
      results.sort_by { |result| [result.locale, result.key] }
    end

    private

    def locale_key(locale, key)
      "#{locale}\0#{key}"
    end

    def search_key
      key.to_s.strip
    end

    def search_value
      value.to_s.strip
    end

    def match_key?(target_key)
      return true if search_key.blank?

      target_key.to_s.include?(search_key)
    end

    def default_db_results
      yml_index = self.class.yml_entries_index
      results = []

      each_db_record do |record|
        result = SearchResult.from_db(record)
        yml_value = yml_index[locale_key(record.locale, record.key)]
        result.merge_yml!(yml_value) if yml_value
        results << result
      end
      results.sort_by { |result| [result.locale, result.key] }
    end

    def each_db_record
      translations = ::Translation.all
      translations = translations.where(locale: self.locale) if self.locale.present?
      translations = translations.where(scope: self.scope) if self.scope.present?
      translations.order(:locale, :key).find_each do |record|
        yield record
      end
    end

    class << self
      def yml_entries
        @yml_entries ||= load_yml_entries
      end

      def yml_entries_index
        @yml_entries_index ||= yml_entries.each_with_object({}) do |entry, memo|
          memo["#{entry.locale}\0#{entry.key}"] = entry.yml_value
        end
      end

      def reset_yml_cache!
        @yml_entries = nil
        @yml_entries_index = nil
      end

      private

      def load_yml_entries
        simple_backend = find_simple_backend
        return [] unless simple_backend

        simple_backend.send(:init_translations) unless simple_backend.initialized?
        translations = simple_backend.send(:translations)
        entries = []

        translations.each do |locale, tree|
          next unless tree.is_a?(Hash)

          flatten_translations(tree).each do |key, value|
            next if value.is_a?(Hash)

            entries << SearchResult.from_yml(locale: locale, key: key, value: value)
          end
        end
        entries
      end

      def find_simple_backend
        backend = I18n.backend
        if backend.is_a?(I18n::Backend::Chain)
          backend.backends.find { |b| b.is_a?(I18n::Backend::Simple) }
        elsif backend.is_a?(I18n::Backend::Simple)
          backend
        end
      end

      def flatten_translations(hash, prefix = nil)
        hash.each_with_object({}) do |(raw_key, raw_value), memo|
          key = prefix ? "#{prefix}.#{raw_key}" : raw_key.to_s
          if raw_value.is_a?(Hash)
            memo.merge!(flatten_translations(raw_value, key))
          else
            memo[key] = raw_value
          end
        end
      end
    end
  end
end
