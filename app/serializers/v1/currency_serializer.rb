class V1::CurrencySerializer < ApplicationSerializer
  attributes :uuid, :name, :symbol, :volume,
  :market_capitalization, :image, :exchanges, :price
end
