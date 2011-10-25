module Pling
  module Mobilant
    module DeviceHelper

      def canonized_identifier
        id = identifier.to_s.strip
        
        return nil if id.nil?
        
        id.sub!(/^\+/, '00')
        id.gsub!(/\s+/, '')
        id.sub!(/^01/, '00491')
        id = "00#{id}" unless id =~ /^00/
        
        return nil unless valid_mobile_phone_number?(id)
        
        id
      end

      def identifier_is_valid_mobile_phone_number?
        !!canonized_identifier
      end
      
      private
      
      def valid_mobile_phone_number?(number)
        return false unless number
        return false unless number =~ /^\d+$/
        return false unless number.length > 4 && number.length <= 16
        true
      end

    end
  end
end
