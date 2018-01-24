class CurrencySerializer < ActiveModel::Serializer
  attributes :uuid, :name, :initials, :volume,
              :market_capitalization, :image, :exchanges, :price
end
