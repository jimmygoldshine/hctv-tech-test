class CumulativeQuantityDiscount

  attr_reader :id, :delivery_method, :quantity_threshold, :discount

  def initialize(args)
    @id = object_id
    @delivery_method = args[:delivery_type].type
    @quantity_threshold = args[:quantity_threshold]
    @discount = args[:discount]
  end

  def discounted_value(order)
    discounted_value = 0.00
    order.shopping_bag.each_pair do |delivery_type, broadcaster_list|
      if delivery_type.type == delivery_method && broadcaster_list.size >= quantity_threshold
        discounted_value += (broadcaster_list.size * delivery_type.price) * discount
      end
    end
    discounted_value
  end

end
