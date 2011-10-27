require 'pling'

module Pling

  class InvalidRecipient           < Error; end

  class InvalidSender              < Error; end

  class InvalidRoute               < Error; end

  class InvalidMessageText         < Error; end

  class InvalidMessageType         < Error; end

  class InvalidRoute               < Error; end

  class InsufficientCredits        < Error; end

  class NetworkNotSupportedByRoute < Error; end

  class FeatureNotSupportedByRoute < Error; end

  module Mobilant

    def self.error_by_response_code(code)
      case code.to_s.to_i
      when 10 then InvalidRecipient
      when 20 then InvalidSender
      when 30 then InvalidMessageText
      when 31 then InvalidMessageType
      when 40 then InvalidRoute
      when 50 then AuthenticationFailed
      when 60 then InsufficientCredits
      when 70 then NetworkNotSupportedByRoute
      when 71 then FeatureNotSupportedByRoute
      when 80 then DeliveryFailed
      else
        nil
      end
    end

  end

end
