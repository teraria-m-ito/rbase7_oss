class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.string   :site_name
      t.string   :status_div, default: 'before_apply'
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
