module Pling
  module Gateway
    class Mobilant < Base
      
      handles :sms, :mobilant
      
      def deliver(message, device)
        message = Pling._convert(message, :message)
        device  = Pling._convert(device,  :device)
      end
      
    end
  end
end