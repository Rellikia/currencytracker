class TrackerService

  def updateCurrencies
    result = Connectors::CoinMarketCap.tickers
  end

end