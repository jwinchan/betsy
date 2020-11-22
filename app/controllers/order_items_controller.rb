class OrderItemsController < ApplicationController
  before_action :find_order_item, only: [:shipped, :cancelled, :update, :destroy]
  before_action :chosen_product, only: [:create, :update]

  def create # create/update shopping cart on product pages
    @order_item = Orderitem.find_by(order_id: order_cart, product_id: params[:product_id])

    if @order_item.nil?
      qty_limit = chosen_product.stock - params[:quantity].to_i

      if qty_limit < 0 
        flash[:error] = "You couldn't order more than the stock quantity."
        redirect_back(fallback_location: root_path)
        return
      elsif params[:quantity].to_i <= 0
        flash[:error] = "Purchasing quantity must greater than 0!"
        redirect_back(fallback_location: root_path)
        return
      end  

      @order_item = Orderitem.new(quantity: order_item_params)
      update_orderitem 
      
      if @order_item.save 
        flash[:success] = "Successfully added this item to your cart!"
        redirect_back(fallback_location: root_path)
        return 
      else
        flash[:error] = "Something went wrong, please try again!"
        redirect_back(fallback_location: root_path)
        return
      end
    else
      @order_item.quantity += params[:quantity].to_i
      @order_item.price += chosen_product.price * params[:quantity].to_i
      qty_limit = chosen_product.stock - @order_item.quantity

      if qty_limit < 0 
        flash[:error] = "You couldn't order more than the stock quantity."
        redirect_back(fallback_location: root_path)
        return
      elsif @order_item.quantity <= 0
        flash[:error] = "Purchasing quantity must greater than 0!"
        redirect_back(fallback_location: root_path)
        return
      elsif @order_item.save 
        flash[:success] = "Successfully updated this item in your cart!"
        redirect_back(fallback_location: root_path)
        return 
      else
        flash[:error] = "Something went wrong, please try again!"
        redirect_back(fallback_location: root_path)
        return
      end
    end
  end

  def update # update shopping cart on shopping cart page
    @order_item = @cart.orderitems.find_by(orderitem_id: chosen_product.id)

    if @order_item.nil?
      flash[:error] = "Could not find this product"
    else
      update_orderitem
      redirect_to cart_path
      return
    end
  end

  def destroy
    item_name = @order_item.product.name

    if @order_item.nil?
      flash[:error] = "Could not remove Order."
      redirect_to cart_path
      return
    else
      @order_item.destroy
      flash[:success] = "Order Item was successfully deleted."
      redirect_to cart_path
      return
    end
  end

  def shipped
    if @order_item.nil? 
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return
    end

    if session[:user_id].nil?
      flash[:error] = "You must be logged in to edit this item"
      redirect_to root_path
      return
    elsif session[:user_id] == @order_item.product.user_id 
      if !@order_item.shipped && @order_item.order_status == "paid"
        @order_item.update(shipped: true, order_status: "completed")
        flash[:success] = "Successfully completed the order item!"
        redirect_back(fallback_location: root_path)
        return
      else
        flash[:error] = "Current order status is #{@order_item.order_status.capitalize}, can't change shipping status."
        redirect_back(fallback_location: root_path)
        return
      end
    else
      flash[:error] = "Only the Merchant can change the shipping Status."
      redirect_to root_path
      return
    end
  end

  def cancelled
    if @order_item.nil? 
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return
    end

    if session[:user_id].nil?
      flash[:error] = "You must be logged in to edit this item"
      redirect_to root_path
      return
    elsif session[:user_id] == @order_item.product.user_id 
      if !@order_item.cancelled && @order_item.order_status == "paid"
        @order_item.update(cancelled: true, order_status: "cancelled")
        flash[:success] = "Successfully cancelled the order item!"
        redirect_back(fallback_location: root_path)
        return
      else
        flash[:error] = "Current order status is #{@order_item.order_status.capitalize}, can't cancel the order."
        redirect_back(fallback_location: root_path)
        return
      end
    else
      flash[:error] = "Only the Merchant can cancel the Order."
      redirect_to root_path
      return 
    end
  end
    
  private

  def order_item_params
    return params.permit(:quantity, :order_id, :product_id)
  end

  def find_order_item
    @order_item = Orderitem.find_by(id: params[:id])
  end

  def chosen_product
    chosen_product = Product.find_by(id: params[:product_id])
    if chosen_product.nil?
      flash[:error] = "Product not found"
      redirect_to products_path
      return
    else
      return chosen_product
    end
  end

  def update_orderitem
    purchase_product = chosen_product
    return @order_item.update(
      order_id: session[:order_id],
      product_id: purchase_product.id,
      quantity: params[:quantity].to_i,
      price: chosen_product.price * params[:quantity].to_i
    )
  end
end
