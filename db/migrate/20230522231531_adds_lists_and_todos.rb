class AddsListsAndTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.string :session_user_id, null: false, index: true

      t.string :title, null: false
      t.string :permalink, index: { unique: true }

      t.timestamps
    end

    create_table :todos do |t|
      t.references :list
      t.string :session_user_id, null: false, index: true

      t.string  :title, null: false
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
