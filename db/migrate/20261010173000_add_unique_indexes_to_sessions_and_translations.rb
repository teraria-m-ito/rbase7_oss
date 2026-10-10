class AddUniqueIndexesToSessionsAndTranslations < ActiveRecord::Migration[7.0]
  def up
    # 重複データがあるとインデックス作成に失敗するため、事前に検出して中止する
    duplicated_sessions = select_value("SELECT COUNT(*) FROM (SELECT session_id FROM sessions GROUP BY session_id HAVING COUNT(*) > 1) t").to_i
    raise "sessions.session_id に重複が #{duplicated_sessions} 件あります。重複を解消してから再実行してください。" if duplicated_sessions > 0

    duplicated_translations = select_value("SELECT COUNT(*) FROM (SELECT locale, `key` FROM translations GROUP BY locale, `key` HAVING COUNT(*) > 1) t").to_i
    raise "translations の (locale, key) に重複が #{duplicated_translations} 件あります。重複を解消してから再実行してください。" if duplicated_translations > 0

    add_index :sessions, :session_id, unique: true unless index_exists?(:sessions, :session_id)
    add_index :translations, [:locale, :key], unique: true unless index_exists?(:translations, [:locale, :key])
  end

  def down
    remove_index :translations, [:locale, :key] if index_exists?(:translations, [:locale, :key])
    remove_index :sessions, :session_id if index_exists?(:sessions, :session_id)
  end
end
