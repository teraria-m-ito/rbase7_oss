class AddColumnLoginFromAtAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :login_from, :string, comment: "ログイン元"
  end
end
