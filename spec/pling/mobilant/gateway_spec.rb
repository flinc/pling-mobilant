require 'spec_helper'
require 'pling/mobilant'

module Pling
  module Mobilant
    describe Gateway do

      context 'when created with no key' do

        it "should raise an error" do
          expect { Pling::Mobilant::Gateway.new({}) }.to raise_error(ArgumentError, /key is missing/)
        end

      end

      context "when delivering a message to a device" do

        let(:message) { Message.new(:body => "Hello World") }

        let(:device) { Device.new(:identifier => "+49 170 1234567")  }

        let(:key) { 'X' * 23 }

        let(:request) do
          mock('Faraday request').tap do |mock|
            mock.stub(:url).with(an_instance_of(String), an_instance_of(Hash))
          end
        end

        let(:response) do
          mock('Faraday response').tap do |mock|
            mock.stub(:status).and_return(200)
            mock.stub(:body).and_return('100')
          end
        end

        let(:connection) do
          mock('Fraday connection').tap do |mock|
            mock.stub(:get).and_yield(request).and_return(response)
          end
        end

        before do
          Faraday.stub(:new).and_return(connection)
        end 

        subject do
          Pling::Mobilant::Gateway.new(:key => key)
        end

        it "should deliver the message if both, message and device, are valid and the gateway is configured properly" do
          request.should_receive(:url).with("https://gw.mobilant.net/", {
                                              :message => 'Hello World',
                                              :to => "00491701234567",
                                              :route => :lowcost,
                                              :key => key
          })

          subject.deliver(message, device)
        end

        it "should raise an exception when the provider reports an invalid recipient" do
          response.should_receive(:body).and_return("10")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::InvalidRecipient)
        end

        it "should raise an exception when the provider reports an invalid sender" do
          response.should_receive(:body).and_return("20")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::InvalidSender)
        end

        it "should raise an exception when the provider reports an message text" do
          response.should_receive(:body).and_return("30")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::InvalidMessageText)
        end

        it "should raise an exception when the provider reports an message type" do
          response.should_receive(:body).and_return("31")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::InvalidMessageType)
        end

        it "should raise an exception when the provider reports an invalid route" do
          response.should_receive(:body).and_return("40")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::InvalidRoute)
        end

        it "should raise an exception when the provider reports that the authentication failed" do
          response.should_receive(:body).and_return("50")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::AuthenticationFailed)
        end

        it "should raise an exception when the provider reports insufficient credits" do
          response.should_receive(:body).and_return("60")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::InsufficientCredits)
        end

        it "should raise an exception when the provider reports an invalid recipient" do
          response.should_receive(:body).and_return("70")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::NetworkNotSupportedByRoute)
        end

        it "should raise an exception when the provider reports an invalid recipient" do
          response.should_receive(:body).and_return("71")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::Mobilant::FeatureNotSupportedByRoute)
        end

        it "should raise an exception when the provider reports an invalid recipient" do
          response.should_receive(:body).and_return("80")
          expect { subject.deliver(message, device) }.
            to raise_error(::Pling::DeliveryFailed)
        end

      end

    end
  end
end
