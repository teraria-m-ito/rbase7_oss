# 開始日時・終了日時。存在しない日付は翌月へ繰り上げず、開始が終了より後なら終了日時をエラーにする。
module CalendarDatetimeRange
  extend ActiveSupport::Concern

  included do
    validate :calendar_datetimes_must_exist
    validate :end_at_not_before_start_at
  end

  def start_at=(value)
    assign_calendar_datetime(:start_at, value)
  end

  def end_at=(value)
    assign_calendar_datetime(:end_at, value)
  end

  def invalid_calendar_datetime(attr)
    invalid_calendar_datetimes[attr.to_sym]
  end

  private

  # 11/31 のように存在しない日付は Time が翌月へ繰り上げる。文字列のままではじく。
  def assign_calendar_datetime(attr, value)
    text = value.is_a?(String) ? value.strip : nil
    match = text&.match(/\A(\d{4})[\/-](\d{1,2})[\/-](\d{1,2})(?:[ T](\d{1,2}):(\d{2})(?::(\d{2}))?)?/)
    impossible = match && (
      !Date.valid_date?(match[1].to_i, match[2].to_i, match[3].to_i) ||
      (match[4] && (
        !(0..23).cover?(match[4].to_i) ||
        !(0..59).cover?(match[5].to_i) ||
        !(0..59).cover?((match[6] || 0).to_i)
      ))
    )
    if impossible
      invalid_calendar_datetimes[attr] = text
      write_attribute(attr, nil)
    else
      invalid_calendar_datetimes.delete(attr)
      write_attribute(attr, value)
    end
  end

  def invalid_calendar_datetimes
    @invalid_calendar_datetimes ||= {}
  end

  def calendar_datetimes_must_exist
    invalid_calendar_datetimes.each_key do |attr|
      errors.add(attr, :invalid_date)
    end
  end

  def end_at_not_before_start_at
    return if start_at.blank? || end_at.blank?
    return if end_at >= start_at

    errors.add(:end_at, :before_start_at)
  end
end
