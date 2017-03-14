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

ActiveRecord::Schema.define(:version => 20140326215409) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "bets", :force => true do |t|
    t.decimal  "quantity",   :precision => 10, :scale => 2
    t.integer  "user_id"
    t.integer  "bid_id"
    t.string   "status"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.float    "realpaid"
  end

  create_table "bids", :force => true do |t|
    t.integer  "product_id"
    t.decimal  "price",          :precision => 5,  :scale => 2
    t.integer  "place"
    t.integer  "nbids_max"
    t.integer  "nbids"
    t.decimal  "maxbid"
    t.decimal  "cost_per_bid",   :precision => 4,  :scale => 2
    t.datetime "endingTime"
    t.time     "firstBidTime"
    t.time     "renewalTime"
    t.boolean  "active"
    t.boolean  "autorenewal"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "userwiner"
    t.boolean  "closed"
    t.boolean  "paid"
    t.decimal  "winnerquantity", :precision => 10, :scale => 2
    t.boolean  "userconfirmed"
  end

  create_table "historicalbets", :force => true do |t|
    t.integer "historicalbid_id"
    t.integer "user_id"
    t.integer "position"
  end

  create_table "historicalbids", :force => true do |t|
    t.integer  "product_id"
    t.integer  "userwiner"
    t.decimal  "winnerquantity",   :precision => 10, :scale => 2
    t.integer  "nbids"
    t.datetime "endingTime"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.float    "earnedmoney"
    t.string   "small_image_url"
    t.string   "medium_image_url"
    t.string   "product_name"
  end

  create_table "offer_codes", :force => true do |t|
    t.decimal  "moneyQuantity"
    t.string   "code"
    t.integer  "freebids"
    t.integer  "halfbids"
    t.datetime "startdate"
    t.datetime "enddate"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "limit"
  end

  create_table "offer_uses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "offercode_id"
    t.string   "ipuse"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "sent"
  end

  create_table "pay_orders", :force => true do |t|
    t.integer  "money"
    t.integer  "user_id"
    t.string   "paytype"
    t.integer  "status"
    t.string   "paypal_transaction_id"
    t.string   "card_transaction_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.decimal  "price",                  :precision => 10, :scale => 2
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "ptype"
    t.string   "image_url_file_name"
    t.string   "image_url_content_type"
    t.integer  "image_url_file_size"
    t.datetime "image_url_updated_at"
    t.string   "english_title"
    t.text     "english_description"
  end

  create_table "provincias", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_hash"
    t.string   "lastname"
    t.string   "name"
    t.string   "mail"
    t.string   "address"
    t.string   "zipcode"
    t.string   "city"
    t.string   "sex"
    t.string   "state"
    t.string   "country"
    t.decimal  "money"
    t.integer  "freebids"
    t.integer  "halfbids"
    t.datetime "lastlogindate"
    t.boolean  "banned"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
