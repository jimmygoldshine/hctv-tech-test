# HCTV Tech Test

## Approach
* Using Ruby, I decided to re-create the sales program from scratch rather than build upon the example given.
* I created three additional classes to implement the promotions solution:
1. CumulativeQuantityDiscount
2. CumulativeValueDiscount
3. ApplyDiscounts

# CumulativeQuantityDiscount
* This class covers the promotions to do with quantity, eg. an order of 2 or more express delivery items.

# CumulativeValueDiscount
* This class covers the promotions to do with total order value eg. order of over $30.

# ApplyDiscounts
* This class calculates the total discount value valid for each order.

## Flexibility
* The solution is designed for flexibility.
* An ApplyDiscounts object can take any number of CumulativeQuantityDiscount and output the correct discount, eg. A discount for 'standard' and a discount for 'express' and any future delivery method.
* An ApplyDiscounts object can take any number of CumulativeValueDiscounts and output the correct discount, eg. a staggered discount system, 10% off over $30, 15% off over $50 etc. It chooses the highest valid discount depending on gross shopping bag value.
* An order does not need any promotion.
* One instance of the ApplyDiscounts object can be used on multiple orders.

## Examples
* Download this repo.
* cd into hctv-tech-test folder.
* run ```$ ruby examples.rb``` to see output of the two given examples from the brief.
