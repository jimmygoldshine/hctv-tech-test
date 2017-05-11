class Order

  attr_reader :material, :shopping_bag, :gross_shopping_bag_value, :discount_value

  def initialize(material)
    @material = material.id
    @shopping_bag = {}
    @gross_shopping_bag_value = 0.00
    @discount_value = 0.00
  end

  def add_item(broadcaster, delivery)
    error_if_broadcaster_is_aleady_in_shopping_bag(broadcaster)
    (shopping_bag[delivery] ||= []).push(broadcaster)
  end

  def total(apply_discounts_obj)
    pre_discount_total + calculate_discount(apply_discounts_obj)
  end

  private

  attr_writer :shopping_bag, :gross_shopping_bag_value, :discount_value

  def calculate_discount(apply_discounts_obj)
    self.discount_value = apply_discounts_obj.apply(self)
  end

  def error_if_broadcaster_is_aleady_in_shopping_bag(broadcaster)
    shopping_bag.each_value do |broadcaster_list|
      if broadcaster_list.include?(broadcaster)
        raise "Error: Broadcaster is already in shopping bag"
      end
    end
  end

  def pre_discount_total
    shopping_bag.each_pair do |delivery, broadcaster_list|
      self.gross_shopping_bag_value += (delivery.price * broadcaster_list.size)
    end
    gross_shopping_bag_value
  end

end
