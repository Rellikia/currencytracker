module RestConnectors
  class CryptonatorConnector

    def self.tickers(base, target)
      response = RestConnectors::Base.call(
        endpoint: "#{ENV['API_URL_CRYPTONATOR']}/#{}",
        method: 'get' )
    end

  end
end