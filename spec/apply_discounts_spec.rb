require 'spec_helper'

describe ApplyDiscounts do

  let(:standard_delivery) { instance_double("Delivery", :type => "standard", :price => 10.00) }
  let(:express_delivery) { instance_double("Delivery", :type => "express", :price => 20.00) }
  let(:value_discount) { CumulativeValueDiscount.new(
                              :shopping_bag_value_threshold => 30.00,
                              :discount => 0.1) }
  let(:value_discount_2) { CumulativeValueDiscount.new(
                              :shopping_bag_value_threshold => 50.00,
                              :discount => 0.2) }
  let(:quantity_discount) { CumulativeQuantityDiscount.new(
                              :delivery_type => express_delivery,
                              :quantity_threshold => 2,
                              :discount => 0.25) }
  let(:quantity_discount_2) { CumulativeQuantityDiscount.new(
                              :delivery_type => standard_delivery,
                              :quantity_threshold => 3,
                              :discount => 0.1) }

  describe "PRIVATE: #apply_quantity_discounts(order)" do

    context "No quantity discount should be applied" do

      let(:order) { instance_double("Order", :shopping_bag => { standard_delivery => ["disney", "discovery", "viacom"],
                                                                express_delivery => ["horse and country"] },
                                             :shopping_bag_value => 50.00) }
      let(:promotion) { described_class.new([value_discount, quantity_discount]) }

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_quantity_discounts, order)).to eq(0.00)
      end
    end

    context "One quantity discount should be applied" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"],
                                                                standard_delivery => ["horse and country"] },
                                             :shopping_bag_value => 70.00) }
      let(:promotion) { described_class.new([value_discount, quantity_discount]) }

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_quantity_discounts, order)).to eq(15.00)
      end
    end

    context "Two quantity discounts should be applied" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"],
                                                                standard_delivery => ["horse and country", "itv", "channel 4"] },
                                             :shopping_bag_value => 70.00) }
      let(:promotion) { described_class.new([value_discount, quantity_discount, quantity_discount_2]) }

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_quantity_discounts, order)).to eq(18.00)
      end
    end
  end

  describe "PRIVATE: #apply_value_discounts(shopping_bag_value)" do

    context "No value discount should be applied" do

      shopping_bag_value = 20
      let(:promotion) { described_class.new([value_discount, quantity_discount]) }

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_value_discounts, shopping_bag_value)).to eq(0.00)
      end
    end

    context "only value discount should be applied" do

      shopping_bag_value = 60
      let(:promotion) { described_class.new([value_discount, quantity_discount]) }

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_value_discounts, shopping_bag_value)).to eq(6.00)
      end
    end

    context "largest value discount should be applied" do

      shopping_bag_value = 60
      let(:promotion) { described_class.new([value_discount, value_discount_2, quantity_discount]) }

      it "should deduct the correct amount" do
        expect(promotion.send(:apply_value_discounts, shopping_bag_value)).to eq(12.00)
      end
    end
  end

  describe "#apply" do

    context "Example 1" do

      let(:order) { instance_double("Order", :shopping_bag => { standard_delivery => ["disney", "discovery", "viacom"],
                                                                express_delivery => ["horse and country"] },
                                             :shopping_bag_value => 50.00) }
      let(:promotion) { described_class.new([value_discount, quantity_discount]) }

      it "should return the correct discount" do
        expect(promotion.apply(order)).to eq(-5.00)
      end
    end

    context "Example 2" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney", "discovery", "viacom"] },
                                             :shopping_bag_value => 60.00) }
      let(:promotion) { described_class.new([value_discount, quantity_discount]) }

      it "should return the correct discount" do
        expect(promotion.apply(order)).to eq(-19.50)
      end
    end

    context "Example 3" do

      let(:order) { instance_double("Order", :shopping_bag => { express_delivery => ["disney"] },
                                             :shopping_bag_value => 50.00) }
      let(:promotion) { described_class.new([value_discount, value_discount_2, quantity_discount]) }

      it "should return the correct discount" do
        expect(promotion.apply(order)).to eq(-10.0)
      end
    end
  end

end
