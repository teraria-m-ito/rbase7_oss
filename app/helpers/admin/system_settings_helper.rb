module Admin
  module SystemSettingsHelper
    include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

    # 検索結果の設定値表示用。4行以上のときは先頭3行＋「...」に省略する
    def truncated_setting_value(value, visible_lines: 3)
      return "".html_safe if value.blank?

      lines = value.to_s.split(/\r\n|\r|\n/)
      if lines.size > visible_lines
        br((lines.take(visible_lines) + ["..."]).join("\n"))
      else
        br(value)
      end
    end
  end
end
