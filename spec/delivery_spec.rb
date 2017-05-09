require 'spec_helper'

describe Delivery do

  context "user initializes with non-lowercase 'type' and integer 'price'" do

    type = "StaNdard"
    price = 10
    let(:delivery) { described_class.new(type, price) }

    it "should convert 'type' to lowercase" do
      expect(delivery.type).to eq("standard")
    end

    it "should convert 'price' to 2 decimal float" do
      expect(delivery.price).to eq(10.00)
    end

  end
end
