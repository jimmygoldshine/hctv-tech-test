require './lib/broadcaster'
require './lib/material'
require './lib/delivery'
require './lib/order'
require './lib/calculate_discounts'
require './lib/discounts/cumulative_value_discount'
require './lib/discounts/cumulative_quantity_discount'

# Create all Broadcasters
viacom = Broadcaster.new("Viacom")
disney = Broadcaster.new("Disney")
discovery = Broadcaster.new("Discovery")
itv = Broadcaster.new("ITV")
channel_4 = Broadcaster.new("Channel 4")
bike_channel = Broadcaster.new("Bike Channel")
horse_and_country = Broadcaster.new("Horse and Country")

# Create two delivery products
standard_delivery = Delivery.new("standard", 10)
express_delivery = Delivery.new("express", 20)

# Create two discounts
discount_1 = CumulativeQuantityDiscount.new(delivery_type: express_delivery,
                                        quantity_threshold: 2,
                                        discount: 0.25)
discount_2 = CumulativeValueDiscount.new(shopping_bag_value_threshold: 30,
                                         discount: 0.1)

# Create the discount calculation object
promotion = CalculateDiscounts.new

# Add discount objects to calculation object
promotion.add_discount(discount_1)
promotion.add_discount(discount_2)

puts 'Example 2:'
advertising_material = Material.new("ZDW/EOWW005/010")
puts "Advertising Material: #{advertising_material.id}"
order = Order.new(advertising_material)
order.add_item(disney, express_delivery)
order.add_item(discovery, express_delivery)
order.add_item(viacom, express_delivery)
puts "Added Disney, Discovery and Viacom to order, all for express delivery"
pre_discount_total = order.pre_discount_total
puts "Pre-discount total: $#{'%.2f' % pre_discount_total}"
discount = promotion.apply(order)
puts "Discount: $#{'%.2f' % discount}"
total = pre_discount_total + discount
puts "Order total: $#{'%.2f' % total}"
