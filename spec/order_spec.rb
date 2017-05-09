require 'spec_helper'

describe Order do

  let(:material) { instance_double("Material", :id => "WNP/SWCL001/010") }
  let(:order) { described_class.new(material) }

  it "should have the material's 'clock' publically accessible" do
    expect(order.material).to eq("WNP/SWCL001/010")
  end

  describe "#add_item(broadcaster, delivery)" do

    let(:disney) { instance_double("Broadcaster", :name => "Disney") }
    let(:standard_delivery) { instance_double("Delivery", :type => "standard", :price => 10.00) }

    it "should add broadcaster to correct delivery type in '@shopping_bag'" do
      order.add_item(disney, standard_delivery)
      expect(order.shopping_bag[standard_delivery]).to eq([disney])
    end
  end

end
