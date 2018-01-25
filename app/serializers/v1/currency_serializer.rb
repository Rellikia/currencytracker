class V1::CurrencySerializer < ApplicationSerializer
  attributes :uuid, :name, :initials, :volume, :market_captalization, :image
end
