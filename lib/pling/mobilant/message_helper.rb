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
      
    end
  end
end