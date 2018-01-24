class Currency < ApplicationRecord
  include Uuidable

  has_many :exchanges, dependent: :destroy, foreign_key: :currency_uuid
  has_many :prices, foreign_key: :currency_uuid
end
