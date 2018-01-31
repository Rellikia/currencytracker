class TrackerService

  TARGETS = [:usd, :btc, :eur, :brl]

  def updateCurrencies
    Rails.logger.debug "method=updateCurrencies class=TrackerService"
    results = RestConnectors::CoinMarketCap.tickers

    results.each do |result|

      currency = build_currency(result)
      currency.save!

      TARGETS.each do |target|
        next if currency.symbol.to_s == target.to_s

        response = RestConnectors::Cryptonator.ticker(currency.symbol, target)

        next unless response && response.fetch("success", false)

        ticker = response.fetch("ticker", nil) if response && response.fetch("ticker", nil)

        next if ticker.fetch("price", nil).present?
        
        currency.price = build_price(currency.price, target, ticker.fetch("price", nil), currency: currency)
        currency.price.save!

        next if ticker.fetch("markets", nil).blank? || !currency.volume.present?

        currency.volume = ticker.fetch("volume", nil)

        ticker["markets"].each do |market|
          exchange = build_exchange(target, market, currency)
          exchange.save!
          exchange.price = build_price(exchange.price, target, market.fetch("price", nil), exchange: exchange)
          exchange.price.save!
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
      currency.symbol = ticker.fetch("symbol", nil).downcase
      currency.image = "#{ENV["CURRENCY_IMAGE_URL_BASE"]}/#{currency.symbol}.png"
      Rails.logger.info "name=#{currency.name} symbol=#{currency.symbol} message=[new currency found]"
    end

    currency.market_capitalization = ticker.fetch("market_cap_usd", nil)
    currency
  end

  def build_price(price, quoted_currency, quoted_value, associations)
    unless price.present?
      price = Price.new
      price.currency = associations[:currency] if associations[:currency].present?
      price.exchange = associations[:exchange] if associations[:exchange].present?
    end

    price.send(quoted_currency, quoted_value)
    price
  end

  def build_exchange(target, market, currency)
    exchange = currency.exchanges.select { |e| e.name == market["name"] }.first if currency.exchanges.present?
    
    unless exchange.present?
      exchange = Exchange.new
      exchange.name = market.fetch("name", nil)
      exchange.currency = associations[:currency] if associations[:currency]
      Rails.logger.info "name=#{currency.name} symbol=#{currency.symbol} exchange=#{exchange.name} message=[new exchange listing currency]"
    end

    exchange.volume = market.fetch("volume", nil)
    exchange
  end

end