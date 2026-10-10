# Be sure to restart your server when you modify this file.

# クリックジャッキング対策。画面を iframe に埋め込めるのは、自サイトと環境変数 LMS_HOST で指定した LMS だけにする。
#   LMS_HOST="canvas.example.ac.jp"                                       … https:// を補う
#   LMS_HOST="https://canvas.example.ac.jp, https://moodle.example.ac.jp" … 複数はカンマまたは空白区切り
# LMS_HOST が未設定の場合は、自サイト以外からの埋め込みを禁止する。
# X-Frame-Options では特定サイトだけを許可できないため、frame-ancestors のみを指定する（他の読み込み制限は行わない）。
lms_hosts = ENV.fetch("LMS_HOST", "").split(/[\s,]+/).reject(&:blank?).map do |host|
  host.match?(%r{\A[a-z][a-z0-9+.-]*://}i) ? host.chomp("/") : "https://#{host.chomp("/")}"
end

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.frame_ancestors :self, *lms_hosts
  end
end
