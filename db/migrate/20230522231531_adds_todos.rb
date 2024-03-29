class AddsTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :session_user_id, null: false, index: true

      t.string  :title, null: false
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
