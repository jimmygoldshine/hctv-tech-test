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

  describe "PRIVATE: #apply_quantity_discounts(order)" do

    context "No quantity discount should be applied" do

      let(:order) { instance_double("Order", :shopping_bag => { standard_delivery => ["disney", "discovery", "viacom"],
                                                                express_delivery => ["horse and country"] }) }
      it "should deduct the correct amount" do
        expect(promotion.send(:apply_quantity_discounts, order)).to eq(0.00)
      end
    end

    context "One quantity discount should be applied" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"],
                                                                standard_delivery => ["horse and country"] }) }
      it "should deduct the correct amount" do
        expect(promotion.send(:apply_quantity_discounts, order)).to eq(15.00)
      end
    end

    context "Two quantity discounts should be applied" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"],
                                                                standard_delivery => ["horse and country", "itv", "channel 4"] }) }
      it "should deduct the correct amount" do
        promotion.add_discount(quantity_discount_2)
        expect(promotion.send(:apply_quantity_discounts, order)).to eq(18.00)
      end
    end
  end

  describe "PRIVATE: #apply_value_discounts(gross_shopping_bag_value)" do

    context "No value discount should be applied" do

      gross_shopping_bag_value = 20.00

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_value_discounts, gross_shopping_bag_value)).to eq(0.00)
      end
    end

    context "only value discount should be applied" do

      gross_shopping_bag_value = 60.00

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_value_discounts, gross_shopping_bag_value)).to eq(6.00)
      end
    end

    context "largest value discount should be applied" do

      gross_shopping_bag_value = 60.00

      it "should deduct the correct amount" do
        promotion.add_discount(value_discount_2)
        expect(promotion.send(:apply_value_discounts, gross_shopping_bag_value)).to eq(12.00)
      end
    end
  end

  describe "#apply" do

    context "Example 1" do

      let(:order) { instance_double("Order", :shopping_bag => { standard_delivery => ["disney", "discovery", "viacom"],
                                                                express_delivery => ["horse and country"] },
                                             :gross_shopping_bag_value => 50.00) }

      it "should return the correct discount" do
        expect(promotion.apply(order)).to eq(-5.00)
      end
    end

    context "Example 2" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"] },
                                             :gross_shopping_bag_value => 60.00) }

      it "should return the correct discount" do
        expect(promotion.apply(order)).to eq(-19.50)
      end
    end

    context "Example 3" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney"] },
                                             :gross_shopping_bag_value => 50.00) }

      it "should return the correct discount" do
        promotion.add_discount(value_discount_2)
        expect(promotion.apply(order)).to eq(-10.0)
      end
    end
  end

end
