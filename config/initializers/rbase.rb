# カレントディレクトリに依存せず読み込めるよう、アプリのルートからの絶対パスで指定する
require Rails.root.join('rbase_gems/load_plugins').to_s
