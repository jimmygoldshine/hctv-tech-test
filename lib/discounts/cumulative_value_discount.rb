class CumulativeValueDiscount

  attr_reader :id, :shopping_bag_value_threshold, :discount

  def initialize(args)
    @id = object_id
    @shopping_bag_value_threshold = args[:shopping_bag_value_threshold]
    @discount = args[:discount]
  end

  def discount_value(shopping_bag_value)
    discounted_value = 0.00
    discounted_value += (shopping_bag_value * discount)
    discounted_value
  end

end
