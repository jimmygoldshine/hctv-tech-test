class CalculateDiscounts

  attr_reader :discounts, :shopping_bag, :shopping_bag_value

  def initialize
    @discounts = []
  end

  def add_discount(discount)
    raise "Error: That discount has already been added" if discounts.include?(discount)
    discounts << discount
  end

  def apply(order)
    total_discount = 0.00
    sorted_discounts_quantity_first.each do |discount|
      if cumulative_value_discount?(discount)
        largest_qualifying_discount = select_appropriate_value_discount(order.gross_shopping_bag_value)
        net_shopping_bag_value = order.gross_shopping_bag_value - total_discount
        total_discount += largest_qualifying_discount.discount_value(net_shopping_bag_value)
        return total_discount
      end
      total_discount += discount.discount_value(order.shopping_bag)
    end
    total_discount
  end

  private

  def sorted_discounts_quantity_first
    discounts.sort { |a,b| a.class.to_s <=> b.class.to_s }
  end

  def cumulative_value_discount?(discount)
    discount.class == CumulativeValueDiscount
  end

  def sort_value_discounts_max_to_min
    value_discounts = discounts.select { |discount| cumulative_value_discount?(discount) }
    sorted_value_discounts = value_discounts.sort_by { |value_discount| value_discount.shopping_bag_value_threshold }.reverse
  end

  def select_appropriate_value_discount(shopping_bag_value)
    sorted_value_discounts = sort_value_discounts_max_to_min
    sorted_value_discounts.each do |value_discount|
      if shopping_bag_value >= value_discount.shopping_bag_value_threshold
        return value_discount
      end
    end
    discount = 0.00
  end

end
