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
      
    end
  end
end