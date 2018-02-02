class Price < ApplicationRecord
  include Uuidable

  belongs_to :currency, foreign_key: :currency_uuid, optional: true
  belongs_to :exchange, foreign_key: :exchange_uuid, optional: true

  validate :has_any_price?

  def has_any_price?
    [:usd, :btc, :eur, :brl].any? { |e| self.send(e).present? }
  end

end
