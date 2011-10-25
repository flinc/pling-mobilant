require 'spec_helper'
require 'pling/mobilant/message_helper'

module Pling
  module Mobilant
    describe "Message when extended with MessageHelper" do
    
      subject { Message.new(:body => "X" * 160).extend(MessageHelper) }
      
      its(:length) { should be == 160 }
      its(:encoding) { should be == 'UTF-8'}
      
      it "should be considered overlong if it is longer than 160 characters" do
        subject.body = 'X' * 161
        subject.should be_overlong
      end
      
    end
  end
end