class Exchange < ApplicationRecord
  include Uuidable

  belongs_to :currency, foreign_key: :currency_uuid
  has_many :prices, foreign_key: :exchange_uuid

  validates_presence_of :name
  
end
