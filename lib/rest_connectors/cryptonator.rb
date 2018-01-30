module RestConnectors
  class Cryptonator

    def self.ticker(base, target)
      response = RestConnectors::Base.call(
        endpoint: "#{ENV['API_URL_CRYPTONATOR']}/#{base}-#{target}",
        method: 'get' )
    end

  end
end