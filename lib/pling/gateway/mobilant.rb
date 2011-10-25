require 'faraday'

require 'pling/mobilant'
require 'pling/mobilant/message_helper'
require 'pling/mobilant/device_helper'

module Pling
  module Gateway
    class Mobilant < Base

      handles :sms, :mobilant

      def _deliver(message, device)
        message.extend(::Pling::Mobilant::MessageHelper)
        device.extend(::Pling::Mobilant::DeviceHelper)

        params = {}

        # require url parameter
        params[:message] = message.url_encoded
        params[:to]      = device.canonized_identifier
        params[:route]   = route
        params[:key]     = configuration[:key]
        
        # optional url parameter
        params[:from]    = source if source
        params[:debug]   = debug  if debug

        connection.get do |request|
          request.url(configuration[:delivery_url], params)
        end
      end

      def initialize(configuration)
        setup_configuration(configuration, :require => [:key])
      end

      private

        def default_configuration
          super.merge({
                        :delivery_url => 'https://gw.mobilant.net/',
                        :adapter => :net_http,
                        :connection => {},
                        :route => :lowcost,
                        :source => nil,
                        :debug => nil
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

    end
  end
end
