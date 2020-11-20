class OrderItemsController < ApplicationController
  def create
    chosen_product = Product.find(params[:product_id])
    if chosen_product.nil?
      flash[:error] = "Product not found"
      redirect_to products_path
      return
    end
    
    # current shopping cart
    current_cart = order_cart 
    if current_cart.products.include?(chosen_product)
      @order_item = current_cart.order_items.find_by(product_id: chosen_product.id)
      @order_item.quantity += 1
      # we can access the price from product, may not need "price" in order_item
      @order_item.price *= @order_item.quantity
    else
      @order_item = OrderItem.new
      @order_item.order_id = current_cart
      @order_item.product_id = chosen_product.id
      @order_item.quantity = 1
      @order_item.price = chosen_product.price
    end
    
    @order_item.save
    redirect_to cart_path(current_cart)
  end
    
  private
  def order_item_params 
    params.require(:order_item).permit(:quantity, :price, :product_id, :order_id)
  end
end
