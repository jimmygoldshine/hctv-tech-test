require 'spec_helper'

describe Order do

  let(:discovery) { instance_double("Broadcaster", :name => "Discovery") }
  let(:disney) { instance_double("Broadcaster", :name => "Disney") }
  let(:standard_delivery) { instance_double("Delivery", :type => "standard", :price => 10.00) }
  let(:express_delivery) { instance_double("Delivery", :type => "express", :price => 20.00) }
  let(:material) { instance_double("Material", :id => "WNP/SWCL001/010") }
  let(:order) { described_class.new(material) }

  it "should have the material's 'clock' publically accessible" do
    expect(order.material).to eq("WNP/SWCL001/010")
  end

  describe "#add_item(broadcaster, delivery)" do

    before do
      order.add_item(disney, standard_delivery)
    end

    it "should add broadcaster to correct delivery type in 'shopping_bag'" do
      expect(order.shopping_bag[standard_delivery]).to eq([disney])
    end

    it "should add another broadcaster to correct delivery type in 'shopping_bag'" do
      order.add_item(discovery, standard_delivery)
      expect(order.shopping_bag[standard_delivery]).to eq([disney,discovery])
    end

    it "should raise an error if broadcaster is already in 'shopping_bag'" do
      expect{ order.add_item(disney, express_delivery) }.to raise_error(RuntimeError, /Error: Broadcaster is already in shopping bag/)
    end
  end

  describe "#pre_discount_total" do

    before do
      order.add_item(disney, standard_delivery)
      order.add_item(discovery, express_delivery)
    end

    it "should total up the correct price (before applying discounts)" do
      expect(order.pre_discount_total).to eq(30.00)
    end

  end

end
