module Connector
  class CoinMarketCap

    def self.tickers
      response = Connectors::Base.call(
        endpoint: "#{ENV['API_URL_COINMARKETCAP']}",
        method: 'get' )
    end

    def self.ticker_by_id(id)
      response = Connectors::Base.call(
        endpoint: "#{ENV['API_URL_COINMARKETCAP']}/#{id}",
        method: 'get' )
    end

  end
end