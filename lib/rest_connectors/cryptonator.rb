module Connectors
  class CryptonatorConnector

    def self.tickers(base, target)
      response = Connectors::Base.call(
        endpoint: "#{ENV['API_URL_CRYPTONATOR']}/#{}",
        method: 'get' )
    end

  end
end