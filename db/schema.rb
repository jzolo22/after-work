# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_19_200128) do

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "occupation"
    t.boolean "dog_allergy"
    t.boolean "outgoing"
    t.boolean "alcohol_problem"
    t.integer "num_drinks"
    t.integer "anxiety_points"
    t.boolean "single"
  end

  create_table "login_sessions", force: :cascade do |t|
    t.integer "character_id"
    t.integer "user_id"
    t.integer "anxiety_points"
    t.integer "num_drinks"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
  end

end
