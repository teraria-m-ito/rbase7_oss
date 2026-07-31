class AlterColumnSettingValueAtSystemSettings < ActiveRecord::Migration[7.0]
  def change
    change_column :system_settings, :setting_value, :string, limit: 16000, comment: "設定値"
  end
end
