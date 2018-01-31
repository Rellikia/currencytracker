class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices, id: false do |t|
      t.string :uuid, limit: 42, primary_key: true, null: false
      t.string :usd
      t.string :btc
      t.string :eur
      t.string :brl
      t.string :currency_uuid, foreign_key: true
      t.string :exchange_uuid, foreign_key: true

      t.timestamps
    end

    add_index :prices, :currency_uuid
    add_index :prices, :exchange_uuid
  end
end
