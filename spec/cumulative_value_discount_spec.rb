require 'spec_helper'

describe CumulativeValueDiscount do

  let(:standard_delivery) { instance_double("Delivery", :type => "standard", :price => 10.00) }
  let(:express_delivery) { instance_double("Delivery", :type => "express", :price => 20.00) }
  let(:promotion) { described_class.new(:shopping_bag_value_threshold => 30.00,
                                        :discount => 0.1) }

  it "should have its id publically readible" do
    expect(promotion.id).to be_instance_of(Integer)
  end

  it "should have its shopping_bag_threshold attribute publically readible" do
    expect(promotion.shopping_bag_value_threshold).to eq(30.00)
  end

  it "should have its discount attribute publically readible" do
    expect(promotion.discount).to eq(0.1)
  end

  describe "#discounted_value(order)" do

    let(:order) { instance_double("Order", :shopping_bag => { standard_delivery => ["disney", "discovery", "viacom", "itv"] },
                                           :shopping_bag_value => 40.00) }

    it "should return the correct discount_value" do
      expect(promotion.discount_value(order)).to eq(4)
    end
  end

end
