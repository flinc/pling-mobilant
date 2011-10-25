require 'uri'

module Pling
  module Mobilant
    module MessageHelper
      
      def length
        body.length
      end
      
      def encoding
        'UTF-8'
      end
      
      def overlong?
        length > 160
      end
      
      def url_encoded
        URI.encode(body)
      end
      
    end
  end
end