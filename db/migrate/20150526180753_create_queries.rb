class CreateQueries < ActiveRecord::Migration[6.0]
  def change
    create_table :queries do |t|
      t.integer :admin_user_id, index: true
      t.string :title
      t.string :query_content, limit: 1000
      t.string :target_class
      t.string :query_fields, limit: 1000
      t.string :selected_query_fields, limit: 1000
      t.boolean :shared
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
