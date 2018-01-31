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

ActiveRecord::Schema.define(version: 20180126124109) do

  create_table "currencies", primary_key: "uuid", id: :string, limit: 42, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "symbol"
    t.string "volume"
    t.string "market_capitalization"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_currencies_on_name"
    t.index ["symbol"], name: "index_currencies_on_symbol"
  end

  create_table "exchanges", primary_key: "uuid", id: :string, limit: 42, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "volume"
    t.string "fee"
    t.string "currency_uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_uuid"], name: "index_exchanges_on_currency_uuid"
  end

  create_table "prices", primary_key: "uuid", id: :string, limit: 42, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "usd"
    t.string "btc"
    t.string "eur"
    t.string "brl"
    t.string "currency_uuid"
    t.string "exchange_uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_uuid"], name: "index_prices_on_currency_uuid"
    t.index ["exchange_uuid"], name: "index_prices_on_exchange_uuid"
  end

  create_table "users", primary_key: "uuid", id: :string, limit: 42, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
