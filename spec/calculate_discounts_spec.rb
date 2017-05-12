require 'spec_helper'

describe CalculateDiscounts do

  let(:standard_delivery) { instance_double("Delivery", :type => "standard", :price => 10.00) }
  let(:express_delivery) { instance_double("Delivery", :type => "express", :price => 20.00) }
  let(:value_discount_1) { CumulativeValueDiscount.new(
                              :shopping_bag_value_threshold => 30.00,
                              :discount => 0.1) }
  let(:value_discount_2) { CumulativeValueDiscount.new(
                              :shopping_bag_value_threshold => 50.00,
                              :discount => 0.2) }
  let(:quantity_discount_1) { CumulativeQuantityDiscount.new(
                              :delivery_type => express_delivery,
                              :quantity_threshold => 2,
                              :discount => 0.25) }
  let(:quantity_discount_2) { CumulativeQuantityDiscount.new(
                              :delivery_type => standard_delivery,
                              :quantity_threshold => 3,
                              :discount => 0.1) }
  let(:promotion) { described_class.new }

  before do
    promotion.add_discount(value_discount_1)
    promotion.add_discount(quantity_discount_1)
  end

  describe "#add_discount" do

    context "adding a discount that is not in the discounts array" do

      it "should increase the discounts list by 1" do
        expect { promotion.add_discount(quantity_discount_2) }.to change { promotion.discounts.size }.by(1)
      end
    end

    context "adding a discount that is in the discounts array" do

      it "should raise an error" do
        expect { promotion.add_discount(quantity_discount_1) }.to raise_error(RuntimeError, /Error: That discount has already been added/)
      end
    end

  end



  describe "#apply" do

    context "Example 1" do

      let(:order) { instance_double("Order", :shopping_bag => { standard_delivery => ["disney", "discovery", "viacom"],
                                                                express_delivery => ["horse and country"] },
                                             :gross_shopping_bag_value => 50.00) }

      it "should return the correct discount" do
        expect(promotion.apply(order)).to eq(5.00)
      end
    end

    context "Example 2" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"] },
                                             :gross_shopping_bag_value => 60.00) }

      it "should return the correct discount" do
        expect(promotion.apply(order)).to eq(19.50)
      end
    end

    context "Example 3" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney"] },
                                             :gross_shopping_bag_value => 50.00) }

      it "should return the correct discount" do
        promotion.add_discount(value_discount_2)
        expect(promotion.apply(order)).to eq(10.0)
      end
    end
  end

end
