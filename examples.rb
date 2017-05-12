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

# Add discount objects to CalculateDiscounts object
promotion.add_discount(discount_1)
promotion.add_discount(discount_2)

# Example 1 - one promotions valid

# Create new Advertising Materials
advertising_material_1 = Material.new("WNP/SWCL001/010")

# Create new Order
order_1 = Order.new(advertising_material_1)

order_1.add_item(disney, standard_delivery)
order_1.add_item(discovery, standard_delivery)
order_1.add_item(viacom, standard_delivery)
order_1.add_item(horse_and_country, express_delivery)

puts 'Example 1:'
total_1 = order_1.total(promotion)
puts "Order total: $#{'%.2f' % total_1}"

# Example 2 - both promotions valid

advertising_material_2 = Material.new("ZDW/EOWW005/010")
order_2 = Order.new(advertising_material_2)
order_2.add_item(disney, express_delivery)
order_2.add_item(discovery, express_delivery)
order_2.add_item(viacom, express_delivery)

puts 'Example 2:'
total_2 = order_2.total(promotion)
puts "Order total: $#{'%.2f' % total_2}"


# Example 3 - no promotion

advertising_material_3 = Material.new("ZDW/EOWW005/010")
order_3 = Order.new(advertising_material_3)
order_3.add_item(disney, express_delivery)
order_3.add_item(discovery, express_delivery)
order_3.add_item(viacom, express_delivery)

puts 'Example 3:'
total_3 = order_3.total
puts "Order total: $#{'%.2f' % total_3}"
