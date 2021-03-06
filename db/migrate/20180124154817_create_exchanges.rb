class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges, id: false do |t|
      t.string :uuid, limit: 42, primary_key: true, null: false
      t.string :name
      t.string :volume
      t.string :fee
      t.string :currency_uuid

      t.timestamps
    end

    add_index :exchanges, :currency_uuid
  end
end
