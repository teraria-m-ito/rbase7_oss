# respond_with のリダイレクトを 303 See Other にする。
# DELETE / PATCH 後に 302 を返すと、ブラウザや Turbo が同じメソッドでリダイレクト先を再要求する場合があるため
ActionController::Responder.redirect_status = :see_other
