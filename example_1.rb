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


# Create new Advertising Material
advertising_material = Material.new("WNP/SWCL001/010")

# Create new Order
order = Order.new(advertising_material)

order.add_item(disney, standard_delivery)
order.add_item(discovery, standard_delivery)
order.add_item(viacom, standard_delivery)
order.add_item(horse_and_country, express_delivery)

# Create the discount calculation object
promotion = CalculateDiscounts.new(order)

# Add discount objects to calculation object
promotion.add_discount(discount_1)
promotion.add_discount(discount_2)

require 'pry'; binding.pry

puts 'Example 1:'
puts "Advertising Material: #{advertising_material.id}"
puts "Added Disney, Discovery and Viacom to order, all for standard delivery"
puts "Added Horse and Country for express delivery"
puts "Pre-discount total: $#{'%.2f' % pre_discount_total}"
discount = order.calculate_discount(promotion)
puts "Discount: $#{'%.2f' % discount}"
total = pre_discount_total + discount
puts "Order total: $#{'%.2f' % total}"
