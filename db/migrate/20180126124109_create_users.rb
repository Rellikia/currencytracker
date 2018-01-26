class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: false do |t|
      t.string :uuid, limit: 42, primary_key: true, null: false
      t.string :api_key

      t.timestamps
    end
  end
end
