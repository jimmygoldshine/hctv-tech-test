class Promotion

  attr_reader :discounts

  def initialize(discounts)
    @discounts = discounts
  end

  def apply(order)
    -(apply_qunatity_discounts(order) + apply_value_discounts(order.shopping_bag_value))
  end

  private

  def select_cumulative_value_discounts(discounts)
    discounts.select { |discount| discount.class == CumulativeValueDiscount }
  end

  def apply_quantity_discounts(order)
    total_discount = 0.00
    discounts.each do |discount|
      if discount.is_a?(CumulativeQuantityDiscount)
        total_discount += discount.discount_value(order)
      end
    end
    total_discount
  end

  def apply_value_discounts(shopping_bag_value)
    total_discount = 0.00
    value_discounts = select_cumulative_value_discounts(discounts)
    value_discounts = value_discounts.map do |value_discount|
      value_discount.discount_value(shopping_bag_value)
    end
    largest_discount = value_discounts.max
    largest_discount ? largest_discount : 0.00
  end

end
