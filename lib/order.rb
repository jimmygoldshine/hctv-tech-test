class Order

  attr_reader :material, :shopping_bag, :shopping_bag_value

  def initialize(material)
    @material = material.id
    @shopping_bag = {}
    @shopping_bag_value = 0.00
  end

  def add_item(broadcaster, delivery)
    check_broadcaster_is_absent_from_shopping_bag(broadcaster)
    (shopping_bag[delivery] ||= []).push broadcaster
  end

  def pre_discount_total
    shopping_bag.each_pair do |delivery, broadcaster_list|
      self.shopping_bag_value += (delivery.price * broadcaster_list.size)
    end
    shopping_bag_value
  end

  private

  attr_writer :shopping_bag, :shopping_bag_value

  def check_broadcaster_is_absent_from_shopping_bag(broadcaster)
    shopping_bag.each_value do |broadcaster_list|
      if broadcaster_list.include?(broadcaster)
        raise "Error: Broadcaster is already in shopping bag"
      end
    end
  end

end
