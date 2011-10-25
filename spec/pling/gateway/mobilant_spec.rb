require 'spec_helper'
require 'pling/gateway/mobilant'

module Pling
  module Gateway
    describe Mobilant do

      context 'when created with no key' do

        it "should raise an error" do
          expect { Pling::Gateway::Mobilant.new({}) }.to raise_error(ArgumentError, /key is missing/)
        end

      end

      context "when delivering a message to a device" do

        let(:message) { Message.new(:body => "Hello World") }

        let(:device) { Device.new(:identifier => "00491701234567")  }

        let(:key) { 'X' * 23 }

        let(:request) do
          mock('Faraday request').tap do |mock|
            mock.stub(:url).with(any_args)
          end
        end

        let(:response) do
          mock('Faraday response').tap do |mock|
            mock.stub(:status).and_return(200)
            mock.stub(:body).and_return('')
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

        it "should deliver the message if both, message and device, are valid and the gateway is configured properly" do
          subject = Pling::Gateway::Mobilant.new(:key => key)

          request.should_receive(:url).with("https://gw.mobilant.net/", {
                                              :message => 'Hello World',
                                              :to => "00491701234567",
                                              :route => :lowcost,
                                              :key => key
          })

          subject.deliver(message, device)
        end

      end

    end
  end
end
