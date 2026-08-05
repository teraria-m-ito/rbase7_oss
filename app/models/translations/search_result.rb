module Translations
  # 一覧行用。同一キーの YAML / DB 翻訳をまとめて保持する
  class SearchResult
    attr_reader :locale, :key, :scope, :record, :yml_value, :db_value

    def initialize(locale:, key:, yml_value: nil, db_value: nil, scope: nil, record: nil)
      @locale = locale.to_s
      @key = key.to_s
      @yml_value = yml_value
      @db_value = db_value
      @scope = scope
      @record = record
    end

    def self.from_db(record, yml_value: nil)
      new(
        locale: record.locale,
        key: record.key,
        yml_value: yml_value,
        db_value: record.display_value,
        scope: record.scope,
        record: record
      )
    end

    def self.from_yml(locale:, key:, value:)
      new(locale: locale, key: key, yml_value: value)
    end

    def from_db?
      record.present?
    end

    def from_yml_only?
      record.nil?
    end

    def yml_display_value
      format_value(yml_value)
    end

    def db_display_value
      format_value(db_value)
    end

    # 新規登録時の初期値は YAML 文言を優先
    def value_for_create
      yml_display_value.presence || db_display_value
    end

    def match_value?(needle)
      needle = needle.to_s.strip
      return true if needle.blank?

      yml_display_value.include?(needle) || db_display_value.include?(needle)
    end

    def merge_yml!(value)
      @yml_value = value if value
      self
    end

    def merge_db!(record)
      @record = record
      @db_value = record.display_value
      @scope = record.scope
      self
    end

    def id
      record&.id
    end

    private

    def format_value(value)
      case value
      when String, NilClass, TrueClass, FalseClass
        value.to_s
      else
        value.inspect
      end
    end
  end
end
