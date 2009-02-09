class CartItem
  attr_reader :product, :quantity
  
  def initialize(product)
    @product = product
    @quantity = 1
  end
  
  def increment_quantity
    @quantity += 1
  end
  
  def decrease_quantity
    @quantity -= 1
  end
  
  def id
    @product.id
  end
  
  def title
    @product.title
  end
  
  def price
    @product.price * @quantity
  end

  def quantity
    return @quantity
  end
end
