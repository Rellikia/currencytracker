class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies, id: false do |t|
      t.string :uuid, limit: 42, primary_key: true, null: false
      t.string :name
      t.string :symbol
      t.string :volume
      t.string :market_capitalization
      t.string :image

      t.timestamps
    end

    add_index :currencies, :name
    add_index :currencies, :symbol
  end
end
