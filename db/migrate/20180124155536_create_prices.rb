class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices, id: false do |t|
      t.string :uuid, limit: 42, primary_key: true, null: false
      t.string :quoted_currency
      t.string :quoted_value
      t.string :currency_uuid, foreign_key: true
      t.string :exchange_uuid, foreign_key: true

      t.timestamps
    end

    add_foreign_key :prices, :currencies, column: :currency_uuid, primary_key: :uuid, on_delete: :cascade
    add_foreign_key :prices, :exchanges, column: :exchange_uuid, primary_key: :uuid, on_delete: :cascade
    add_index :prices, :currency_uuid
    add_index :prices, :exchange_uuid
  end
end
