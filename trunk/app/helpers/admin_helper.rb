module AdminHelper
  def get_product(id)
    @product = Product.find(params[:id] = id)
    @product.title
  end
end
