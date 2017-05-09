class CumulationDiscount

  attr_reader :id, :shopping_bag_value_threshold, :discount

  def initialize(args)
    @id = object_id
    @shopping_bag_value_threshold = args[:shopping_bag_value_threshold]
    @discount = args[:discount]
  end

  def discount_value(order)
    discounted_value = 0.00
    if order.shopping_bag_value > shopping_bag_value_threshold
      discounted_value += (order.shopping_bag_value * discount)
    end
    discounted_value
  end

end
