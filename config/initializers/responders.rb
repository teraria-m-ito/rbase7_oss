# respond_with のリダイレクトを 303 See Other にする。
# DELETE / PATCH 後に 302 を返すと、ブラウザや Turbo が同じメソッドでリダイレクト先を再要求する場合があるため
ActionController::Responder.redirect_status = :see_other
# 入力エラーで画面を再表示するときは 422 を返す。Turbo は 200 のフォーム応答を描画しないため
ActionController::Responder.error_status = :unprocessable_entity
