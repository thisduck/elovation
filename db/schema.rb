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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130108195814) do

  create_table "leagues", :force => true do |t|
    t.string   "name",                                :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "result_rule", :default => "any_user"
  end

  create_table "players", :force => true do |t|
    t.string   "name",                                :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "email"
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.string   "role"
  end

  add_index "players", ["email"], :name => "index_players_on_email", :unique => true

  create_table "players_results", :force => true do |t|
    t.integer "player_id", :null => false
    t.integer "result_id", :null => false
  end

  add_index "players_results", ["player_id"], :name => "index_players_results_on_player_id"
  add_index "players_results", ["result_id"], :name => "index_players_results_on_result_id"

  create_table "rating_history_events", :force => true do |t|
    t.integer  "rating_id",  :null => false
    t.integer  "value",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rating_history_events", ["rating_id"], :name => "index_rating_history_events_on_rating_id"

  create_table "ratings", :force => true do |t|
    t.integer  "player_id",  :null => false
    t.integer  "league_id",  :null => false
    t.integer  "value",      :null => false
    t.boolean  "pro",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ratings", ["league_id"], :name => "index_ratings_on_league_id"
  add_index "ratings", ["player_id"], :name => "index_ratings_on_player_id"

  create_table "results", :force => true do |t|
    t.integer  "league_id",  :null => false
    t.integer  "loser_id",   :null => false
    t.integer  "winner_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "poster_id"
  end

  add_index "results", ["league_id"], :name => "index_results_on_league_id"
  add_index "results", ["loser_id"], :name => "index_results_on_loser_id"
  add_index "results", ["poster_id"], :name => "index_results_on_poster_id"
  add_index "results", ["winner_id"], :name => "index_results_on_winner_id"

end
