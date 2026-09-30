class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.string :report_class
      t.string :description, limit: 1000
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
