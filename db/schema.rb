# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_22_231531) do
  create_table "lists", force: :cascade do |t|
    t.string "session_user_id", null: false
    t.string "title", null: false
    t.string "permalink"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permalink"], name: "index_lists_on_permalink", unique: true
    t.index ["session_user_id"], name: "index_lists_on_session_user_id"
  end

  create_table "todos", force: :cascade do |t|
    t.integer "list_id"
    t.string "session_user_id", null: false
    t.string "title", null: false
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_todos_on_list_id"
    t.index ["session_user_id"], name: "index_todos_on_session_user_id"
  end

end