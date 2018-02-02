class TrackerService

  TARGETS = [:usd, :btc, :eur, :brl]
  IGNORE_ERRORS = ["Pair not found"]

  def updateCurrencies
    Rails.logger.debug "method=updateCurrencies class=TrackerService"
    results = RestConnectors::CoinMarketCap.tickers

    unless results.present?
      updateCurrencies
      return
    end

    results.each do |result|

      currency = build_currency(result)
      currency.save!

      TARGETS.each do |target|
        if currency.symbol.to_s == target.to_s
          currency.price.btc = "1" if currency.price.present? && target.to_s == "btc"
          currency.price.save!
          next
        end
        get_tickers(currency, target)
      end

    end

  end

  def get_tickers(currency, target)
    Rails.logger.debug "method=get_tickers target=#{target}"
    response = RestConnectors::Cryptonator.ticker(currency.symbol, target)

    unless response && response.fetch("success", nil) && response.fetch("ticker", nil)
      get_tickers(currency, target) unless IGNORE_ERRORS.include?(response.fetch("error", ""))
      return
    end

    ticker = response.fetch("ticker", nil)
    
    currency.price = build_price(currency.price, target, ticker.fetch("price", nil), currency: currency)
    currency.price.save!

    return unless ticker.fetch("markets", nil).present? || currency.volume.present?

    currency.volume = ticker.fetch("volume", nil)

    ticker["markets"].each do |market|
      exchange = build_exchange(target, market, currency)
      exchange.save!
      exchange.price = build_price(exchange.price, target, market.fetch("price", nil), exchange: exchange)
      exchange.price.save!
    end

    Rails.logger.debug currency.attributes
    currency.save!
  end

  def build_currency(ticker)
    Rails.logger.debug "method=build_currency"
    currency_name = ticker.fetch("name", nil)

    currency = Currency.where(name: currency_name).first_or_initialize

    if !currency.persisted?
      currency.name = currency_name
      currency.symbol = ticker.fetch("symbol", nil).downcase
      currency.image = "#{ENV["CURRENCY_IMAGE_URL_BASE"]}/#{currency.symbol}.png"
      Rails.logger.info "name=#{currency.name} symbol=#{currency.symbol} message=[new currency found]"
    end

    currency.market_capitalization = ticker.fetch("market_cap_usd", nil)
    Rails.logger.debug currency.attributes
    currency
  end

  def build_price(price, quoted_currency, quoted_value, associations)
    Rails.logger.debug "method=build_price quoted_currency=#{quoted_currency} quoted_value=#{quoted_value}"
    unless price.present?
      price = Price.new
      price.currency = associations[:currency] if associations[:currency].present?
      price.exchange = associations[:exchange] if associations[:exchange].present?
      Rails.logger.info "curency=#{associations[:currency].try(:name)} exchange=#{associations[:exchange].try(:name)} message=[new price listing currency]"
    end

    price.send("#{quoted_currency}=", quoted_value)
    Rails.logger.debug price.attributes
    price
  end

  def build_exchange(target, market, currency)
    Rails.logger.debug "method=build_exchange"
    exchange = currency.exchanges.select { |e| e.name == market["name"] }.first if currency.exchanges.present?
    
    unless exchange.present?
      exchange = Exchange.new
      exchange.name = market.fetch("market", nil)
      exchange.currency = currency if currency
      Rails.logger.info "name=#{currency.name} symbol=#{currency.symbol} exchange=#{exchange.name} message=[new exchange listing currency]"
    end

    exchange.volume = market.fetch("volume", nil)
    Rails.logger.debug exchange.attributes
    exchange
  end

end