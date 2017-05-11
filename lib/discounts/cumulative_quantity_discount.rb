class CumulativeQuantityDiscount

  attr_reader :id, :delivery_method, :quantity_threshold, :discount

  def initialize(args)
    @id = object_id
    @delivery_method = args[:delivery_type].type
    @quantity_threshold = args[:quantity_threshold]
    @discount = args[:discount]
  end

  def discount_value(shopping_bag)
    discounted_value = 0.00
    shopping_bag.each_pair do |delivery_type, broadcaster_list|
      if delivery_methods_match?(delivery_type) && enough_broadcasters?(broadcaster_list)
        discounted_value += (broadcaster_list.size * delivery_type.price) * discount
      end
    end
    discounted_value
  end

  private

  def enough_broadcasters?(broadcaster_list)
    broadcaster_list.size >= quantity_threshold
  end

  def delivery_methods_match?(delivery_type_obj)
    delivery_type_obj.type == delivery_method
  end

end
