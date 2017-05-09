require 'spec_helper'

describe Promotion do

  let(:standard_delivery) { instance_double("Delivery", :type => "standard", :price => 10.00) }
  let(:express_delivery) { instance_double("Delivery", :type => "express", :price => 20.00) }

  context 'Example 1' do

    let(:order) { instance_double("Order", :shopping_bag => { standard_delivery => ["disney", "discovery", "viacom"],
                                                              express_delivery => ["horse and country"] },
                                           :shopping_bag_value => 50.00) }
    let(:promotion) { described_class.new(order) }

    it "should deduct the correct amount" do
      expect(promotion.discount).to eq(-5.00)
    end
  end

  context 'Example 2' do

    let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"] },
                                           :shopping_bag_value => 60.00) }
    let(:promotion) { described_class.new(order) }

    it "should deduct the correct amount" do
      expect(promotion.discount).to eq(-19.50)
    end
  end

end
