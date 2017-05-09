require 'spec_helper'

describe CumulativeQuantityDiscount do

  let(:express_delivery) { instance_double("Delivery", :type => "express",
                                                       :price => 20.00) }
  let(:promotion) { described_class.new(:delivery_type => express_delivery,
                                        :quantity_threshold => 2,
                                        :discount => 0.25) }

  it "should have its id publically readible" do
      expect(promotion.id).to be_instance_of(Integer)
  end

  it "should have its shopping_bag_threshold attribute publically readible" do
    expect(promotion.delivery_method).to eq("express")
  end

  it "should have its shopping_bag_threshold attribute publically readible" do
    expect(promotion.quantity_threshold).to eq(2)
  end

  it "should have its discount attribute publically readible" do
    expect(promotion.discount).to eq(0.25)
  end

  describe "#discounted_value(order)" do

    let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom", "itv"] },
                                           :shopping_bag_value => 80.00) }

    it "should return the correct discount_value" do
      expect(promotion.discounted_value(order)).to eq(20)
    end
  end

end
