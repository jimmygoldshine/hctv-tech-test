class Promotion

  EXPRESS_DELIVERY_SAVING = 5.00
  OVER_30_DOLLARS_SAVING = 0.1

  def initialize(order)
    @shopping_bag = order.shopping_bag
    @pre_discount_total = order.shopping_bag_value
  end

  def express_delivery_discount
    discount = 0.00
    shopping_bag.each_pair do |delivery_type, broadcaster_list|
      if delivery_type.type == "express" && broadcaster_list.size > 2
        discount += (broadcaster_list.size * EXPRESS_DELIVERY_SAVING)
      end
    end
    discount
  end

  def over_30_dollars_discount(shopping_bag_value)
    discount = 0.00
    if shopping_bag_value > 30.00
      discount += (shopping_bag_value * OVER_30_DOLLARS_SAVING)
    end
    discount
  end

  def discount
    shopping_bag_value = pre_discount_total - express_delivery_discount
    total_discount = express_delivery_discount + over_30_dollars_discount(shopping_bag_value)
    -total_discount
  end

  private

  attr_reader :shopping_bag, :pre_discount_total

end
