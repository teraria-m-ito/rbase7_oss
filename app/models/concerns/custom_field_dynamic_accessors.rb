# frozen_string_literal: true

# CustomField を field_name 単位で参照する動的ゲッター／セッター。
# custom_field_type ごとのスコープ（display_order 昇順）と、中間レコードの association 名を指定する。
# 既存インスタンスメソッドと field_name が衝突した場合はモデル側が優先（method_missing に届かない）。
module CustomFieldDynamicAccessors
  extend ActiveSupport::Concern

  class_methods do
    # @param association [Symbol] 例: :lms_user_custom_fields, :issue_custom_fields, :admin_user_custom_fields
    # @param data_source [Symbol] 例: :lms_user_custom_fields（DB テーブル存在チェック用）
    # @param custom_field_scope [Proc] CustomField の Relation を返す Proc（display_order はスコープ側で揃える）
    def custom_field_dynamic_accessors!(association:, data_source:, custom_field_scope:)
      @custom_field_dynamic_association = association
      @custom_field_dynamic_data_source = data_source
      @custom_field_dynamic_scope_proc = custom_field_scope
    end

    def reset_custom_field_dynamic_access_cache!
      @custom_field_dynamic_definitions = nil
      @custom_field_dynamic_method_name_index = nil
      @custom_field_dynamic_db_ready = nil
      @integration_row_assignable_columns_by_normalized_key = nil
    end

    def database_ready_for_custom_field_dynamic_access?
      return @custom_field_dynamic_db_ready unless @custom_field_dynamic_db_ready.nil?

      @custom_field_dynamic_db_ready =
        ActiveRecord::Base.connected? &&
        (conn = ActiveRecord::Base.connection) &&
        conn.data_source_exists?(:custom_fields) &&
        @custom_field_dynamic_data_source.present? &&
        conn.data_source_exists?(@custom_field_dynamic_data_source)
    end

    def custom_field_definitions_for_dynamic_access
      @custom_field_dynamic_definitions ||= _load_custom_field_definitions_ordered
    end

    def _load_custom_field_definitions_ordered
      return [] unless database_ready_for_custom_field_dynamic_access?
      return [] if @custom_field_dynamic_scope_proc.blank?

      @custom_field_dynamic_scope_proc.call.to_a
    end

    def custom_field_dynamic_method_name_index
      @custom_field_dynamic_method_name_index ||= custom_field_definitions_for_dynamic_access.each_with_object({}) do |cf, h|
        raw = cf.field_name.to_s.strip
        next if raw.blank?

        h[raw] = cf
        h[raw.downcase] = cf
      end
    end

    def lookup_custom_field_dynamic_definition(name)
      key = name.to_s.strip
      return nil if key.blank?

      custom_field_dynamic_method_name_index[key] || custom_field_dynamic_method_name_index[key.downcase]
    end

    def custom_field_dynamic_association_name
      @custom_field_dynamic_association
    end
  end

  def method_missing(method_name, *args, &block)
    s = method_name.to_s
    base = setter_method_name?(s) ? s.chomp("=") : s
    cf = self.class.lookup_custom_field_dynamic_definition(base)
    if cf
      return write_custom_field_join_record(cf, args.first) if setter_method_name?(s)

      return read_custom_field_join_record(cf)
    end

    super
  end

  def respond_to_missing?(method_name, include_private = false)
    s = method_name.to_s
    base = setter_method_name?(s) ? s.chomp("=") : s
    return true if self.class.lookup_custom_field_dynamic_definition(base)

    super
  end

  # インテグレーション行など、method_missing に頼らずカスタムフィールドへ代入する。
  # @return [Boolean] 対象の CustomField があり代入したとき true
  def assign_custom_field_dynamic_value!(name, value)
    cf = self.class.lookup_custom_field_dynamic_definition(name)
    return false if cf.blank?

    write_custom_field_join_record(cf, value)
    true
  end

  private

  def setter_method_name?(method_name_str)
    method_name_str.end_with?("=") && method_name_str != "="
  end

  def read_custom_field_join_record(custom_field)
    rec = custom_field_join_record_for(custom_field)
    rec&.field_value
  end

  def write_custom_field_join_record(custom_field, value)
    assoc = self.class.custom_field_dynamic_association_name
    rec = custom_field_join_record_for(custom_field)
    rec ||= send(assoc).build(custom_field_id: custom_field.id)
    rec.field_value = value
    value
  end

  def custom_field_join_record_for(custom_field)
    assoc = self.class.custom_field_dynamic_association_name
    send(assoc).detect { |row| row.custom_field_id == custom_field.id }
  end
end
