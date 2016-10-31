# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161031201946) do

  create_table "bets", force: true do |t|
    t.integer  "game_id"
    t.integer  "first"
    t.integer  "second"
    t.integer  "third"
    t.integer  "forth"
    t.integer  "fifth"
    t.integer  "extra"
    t.integer  "extra_one"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bet"
  end

  create_table "feeds", force: true do |t|
    t.date     "next_game_date"
    t.boolean  "as_jackpot"
    t.integer  "prize"
    t.text     "last_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_game_num"
  end

  create_table "games", force: true do |t|
    t.string   "num"
    t.date     "day"
    t.integer  "prize"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "winner_combination"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "playing_rules", force: true do |t|
    t.integer  "minor"
    t.integer  "major"
    t.integer  "number_beats"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responsibles", force: true do |t|
    t.date     "month"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
