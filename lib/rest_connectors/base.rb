require 'net/http'

module RestConnectors
  class Base

    HTTP_METHOD = { post: Net::HTTP::Post, put: Net::HTTP::Put, get: Net::HTTP::Get }

    def self.call(args={})
      begin
        Rails.logger.debug args.to_s
        endpoint = args.fetch(:endpoint)
        method = args.fetch(:method).downcase.to_sym
        headers = args.fetch(:headers) { {} }
        get_params = args[:params]
        json_request = args[:request]

        url = URI( "#{endpoint}?#{get_params.to_query}" ) if get_params
        url ||= URI(endpoint)

        request = HTTP_METHOD[method].new(url, initheader = {'Content-Type': 'application/json'}.merge!(headers) )
        request.body = json_request.to_json if json_request

        response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
          http.request(request)
        end

        log_msg = "class=RestConnector method=call url=[#{url}] request=[#{request.inspect} #{request.try(:body)}] response=[#{response.inspect} #{response.try(:body)}]"
        case response
          when Net::HTTPSuccess, Net::HTTPCreated
            Rails.logger.info log_msg
            JSON.parse(response.body)
          else
            Rails.logger.error "error_key=rest_connection_error #{log_msg}"
            response
          end
      rescue => e
        log_msg = "error_key=rest_connection_error message=[#{e.inspect} #{e.message}] location=[#{e.backtrace_locations.try(:first)}"
        Rails.logger.error log_msg
        {}
      end
    end
  end
end