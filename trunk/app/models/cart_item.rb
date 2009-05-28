class CartItem
  attr_reader :product, :quantity, :phone_id, :plan_id, :mro_amount
  attr_writer :phone_id, :plan_id, :mro_amount
  
  def initialize(product)
    @product = product
    @quantity = 1
    @phone_id = @plan_id = @mro_amount = 0
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

  def description
    @product.description
  end

  def image_url
    @product.image_url
  end

  def quantity
    return @quantity
  end

  def phone_id=(new_id)
    @phone_id = new_id
  end

  def phone_id
    return @phone_id
  end

  def plan_id=(new_id)
    @plan_id = new_id
  end

  def plan_id
    return @plan_id
  end

  def mro_amount=(new_mro)
    @mro_amount = new_mro
  end

  def mro_amount
    return @mro_amount
  end
end
