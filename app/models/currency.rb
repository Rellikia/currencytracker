class Currency < ApplicationRecord
  include Uuidable

  has_many :exchanges, foreign_key: :currency_uuid
  has_one :price, foreign_key: :currency_uuid

  validates_presence_of :name, :symbol, :market_capitalization, :image
end
