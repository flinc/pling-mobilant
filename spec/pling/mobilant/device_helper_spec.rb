require 'spec_helper'
require 'pling/mobilant/device_helper'

module Pling
  module Mobilant
    describe Device do

      numbers = {
        '00491701234567'  => '00491701234567',
        '+491701234567'   => '00491701234567',
        '01701234567'     => '00491701234567',
        '491701234567'    => '00491701234567',
        '+49 170 1234567' => '00491701234567',
        '0049a701234567'  => nil,
        '0049'            => nil,
        '0' * 17          => nil
      }

      numbers.each_pair do |identifier, canonized_identifier|

        context "with device identifier #{identifier}" do

          subject { Device.new(:identifier => identifier, :type => :sms).extend(DeviceHelper)}

          if canonized_identifier
            it "should be considered to have a valid device identifier" do
              subject.identifier_is_valid_mobile_phone_number?.should be == true
            end
          else
            it "should be considered to have an invalid device identifier" do
              subject.identifier_is_valid_mobile_phone_number?.should be == false
            end
          end
          
          it "should have #{canonized_identifier.inspect} as canonized identifier" do
            subject.canonized_identifier.should be == canonized_identifier
          end

        end

      end

    end
  end
end
