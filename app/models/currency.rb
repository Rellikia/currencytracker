class Currency < ApplicationRecord
  include Uuidable

  has_many :exchanges, foreign_key: :currency_uuid
  has_many :prices, foreign_key: :currency_uuid

  validates_presence_of :name, :initials, :market_capitalization, :image
end
