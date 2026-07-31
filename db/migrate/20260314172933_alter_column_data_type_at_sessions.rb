class AlterColumnDataTypeAtSessions < ActiveRecord::Migration[7.0]
  def up
    change_column :sessions, :data, :mediumtext, null: true
  end

  def down
    change_column :sessions, :data, :text, null: true
  end

end
