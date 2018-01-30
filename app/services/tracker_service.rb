class TrackerService

  TARGETS = [:usd, :btc, :eur, :brl]

  def updateCurrencies
    Rails.logger.debug "method=updateCurrencies class=TrackerService"
    results = RestConnectors::CoinMarketCap.tickers

    results.each do |result|

      currency = build_currency(result)
      currency.save!

      TARGETS.each do |target|
        response = RestConnectors::Cryptonator.ticker(currency.initials, target)

        ticker = response.fetch("ticker", nil) if response && response.fetch("ticker", nil)

        next if ticker.fetch("price", nil).blank?

        currency.prices << build_price(target, ticker.fetch("price", nil), currency: currency)

        Rails.logger.debug "##############################"

        next if ticker.fetch("markets", nil).blank? || !currency.volume.blank?

        currency.volume = ticker.fetch("volume", nil)

        ticker["markets"].each do |market|
          exchange = Exchange.new
          exchange.name = market.fetch("name", nil)
          exchange.volume = market.fetch("volume", nil)
          exchange.currency = currency
          exchange.save!

          exchange.prices << build_price(target, market.fetch("price", nil), exchange: exchange)
        end

        Rails.logger.debug currency.attributes
        currency.save!
        Rails.logger.debug currency.attributes
      end

    end

  end

  def build_currency(ticker)
    currency_name = ticker.fetch("name", nil)

    currency = Currency.where(name: currency_name).first_or_initialize

    if !currency.persisted?
      currency.name = currency_name
      currency.initials = ticker.fetch("symbol", nil).downcase
      currency.image = "#{ENV["CURRENCY_IMAGE_URL_BASE"]}/#{currency.initials}.png"
    end

    currency.market_capitalization = ticker.fetch("market_cap_usd", nil)
    currency
  end

  def build_price(quoted_currency, quoted_value, associations)
    price = Price.new
    price.quoted_currency = quoted_currency
    price.quoted_value = quoted_value
    price.currency = associations[:currency]
    price.exchange = associations[:exchange]
    price.save!
  end

end