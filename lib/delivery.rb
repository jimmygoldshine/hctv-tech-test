class Delivery

  attr_reader :type, :price

  def initialize(type, price)
    @type = type.downcase
    @price = price.to_f.round(2)
  end

end
