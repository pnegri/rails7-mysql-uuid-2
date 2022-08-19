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

ActiveRecord::Schema[7.0].define(version: 2022_08_18_223555) do
  create_table "audit_lines", id: { type: :binary, limit: 16 }, charset: "utf8mb4", force: :cascade do |t|
    t.binary "audit_id", limit: 16, null: false
    t.string "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audit_id"], name: "index_audit_lines_on_audit_id"
  end

  create_table "audits", id: { type: :binary, limit: 16 }, charset: "utf8mb4", force: :cascade do |t|
    t.string "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", charset: "utf8mb4", force: :cascade do |t|
    t.binary "other_id", limit: 16
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "audit_lines", "audits"
end
