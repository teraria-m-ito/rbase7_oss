class CreateRole < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string  :role_name
      t.string  :role_short_name
      t.boolean :deletable
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
