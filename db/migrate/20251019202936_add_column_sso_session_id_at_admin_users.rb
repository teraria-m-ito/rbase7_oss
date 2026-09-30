class AddColumnSsoSessionIdAtAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :sso_session_id, :string, comment: "SSOセッションID"
  end
end
