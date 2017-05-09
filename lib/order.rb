class Order

  attr_reader :material, :shopping_bag

  def initialize(material)
    @material = material.id
    @shopping_bag = {}
  end

  def add_item(broadcaster, delivery)
    check_broadcaster_is_absent_from_shopping_bag(broadcaster)
    (shopping_bag[delivery] ||= []).push broadcaster
  end

  def pre_discount_total

  end

  private

  attr_writer :shopping_bag

  def check_broadcaster_is_absent_from_shopping_bag(broadcaster)
    shopping_bag.each_value do |delivery_bag|
      if delivery_bag.include?(broadcaster)
        raise "Error: Broadcaster is already in shopping bag"
      end
    end
  end

end
