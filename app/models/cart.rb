class Cart
  attr_reader :items   
  
  def initialize
    @items = []
  end
  
  def add_product(product, phone_id, plan_id, mro)
    current_item = @items.find {|item| item.product == product}
    
    if current_item
      current_item.increment_quantity
    else
      current_item = CartItem.new(product)
      @items << current_item
    end

    unless phone_id.nil?
      current_item.phone_id = phone_id
    end

    unless plan_id.nil?
      current_item.plan_id = plan_id
    end

    unless mro.nil?
      current_item.mro_amount = mro
    end

    current_item
  end
  
  def remove_product(product)
    current_item = @items.find {|item| item.product == product}
    if current_item
      current_item.decrease_quantity
      if current_item.quantity == 0
        @items.delete current_item      
      end
    end
    current_item
  end
  
  def total_price
    @items.sum { |item| item.price }
  end
  
  def total_items
    @items.sum { |item| item.quantity }
  end
end
