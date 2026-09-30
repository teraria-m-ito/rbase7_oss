module TopHelper
  include ::Rbase::PluginModule::Extendable # 継承を許可する宣言（必須）

  def admin_top_page_content
    content =<<EOS
                <h2>管理者向けお知らせ</h2>
                <p>
                  ここに管理者用のお知らせを記載します。
                </p>
EOS
    content.html_safe
  end

  def manager_top_page_content
    content =<<EOS
                <h2>マネージャ向けお知らせ</h2>
                <p>
                  ここにマネージャ用のお知らせを記載します。
                </p>
EOS
    content.html_safe
  end

  def member_top_page_content
    content =<<EOS
                <h2>メンバー向けお知らせ</h2>
                <p>
                  ここにメンバー用のお知らせを記載します。
                </p>
EOS
    content.html_safe
  end

  def non_login_top_page_content
    content =<<EOS
              <h2>お知らせ</h2>
              <p>
                このサイトはrbase専用サイトです。<br/>
              </p>
EOS
    content.html_safe
  end
end
