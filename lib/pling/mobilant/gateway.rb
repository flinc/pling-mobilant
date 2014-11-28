require 'faraday'

module Pling
  module Mobilant
    class Gateway < ::Pling::Gateway

      handles :sms, :mobilant, :mobile

      def initialize(configuration)
        super
        require_configuration([:key])
      end

      def deliver!(message, device)
        params = {}

        # require url parameter
        params[:message]     = message.body
        params[:to]          = sanitize_identifier(device.identifier)
        params[:route]       = route
        params[:key]         = configuration[:key]
        params[:charset]     = configuration[:charset] if configuration[:charset]
        params[:messagetype] = configuration[:messagetype] if configuration[:messagetype]

        # optional url parameter
        params[:from]    = source if source
        params[:debug]   = debug  if debug

        response = connection.get do |request|
          request.url(configuration[:delivery_url], params)
        end

        response_code = response.body.lines.first

        if error = ::Pling::Mobilant.error_by_response_code(response_code)
          raise error
        else
          nil
        end
      end

      private

        def default_configuration
          super.merge({
            :delivery_url => 'https://gw.mobilant.net/',
            :adapter => :net_http,
            :connection => {},
            :route => :lowcost
          })
        end

        def connection
          @connection ||= Faraday.new(configuration[:connection]) do |builder|
            builder.use Faraday::Request::UrlEncoded
            builder.use Faraday::Response::Logger if configuration[:debug]
            builder.adapter(configuration[:adapter])
          end
        end

        def route
          route = (configuration[:route] || :lowcost)
          [:lowcost, :lowcostplus, :direct, :directplus].include?(route) ? route : raise(::Pling::Mobilant::InvalidRoute, "Invalid route")
        end

        def debug
          configuration[:debug] ? 1 : nil
        end

        def source
          return nil unless configuration[:source]
          configuration[:source].to_s.strip
        end

        def sanitize_identifier(identifier)
          identifier.gsub(/^\+/, "00").gsub(/\D/, '')
        end

    end
  end
end
