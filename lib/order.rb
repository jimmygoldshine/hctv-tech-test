class Order

  attr_reader :material, :shopping_bag

  def initialize(material)
    @material = material.id
    @shopping_bag = {}
  end

  def add_item(broadcaster, delivery)
    (shopping_bag[delivery] ||= []).push broadcaster
  end

  private

  attr_writer :shopping_bag

end
