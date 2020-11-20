class OrderItemsController < ApplicationController
  def create
    chosen_product = Product.find_by(id: params[:product_id])
    if chosen_product.nil?
      flash[:error] = "Product not found"
      redirect_to products_path
      return
    end
    
    # current shopping cart & order_card return order_id
    current_cart = order_cart 

    @order_item = Orderitem.where(order_id: current_cart, product_id: params[:product_id]).first
    if @order_item.nil?
      @order_item = Orderitem.new
      @order_item.order_id = current_cart
      @order_item.product_id = chosen_product.id
      @order_item.quantity = params[:quantity].to_i
      @order_item.price = chosen_product.price
      chosen_product.stock -= params[:quantity].to_i
      if @order_item.save && chosen_product.stock >= 0 && chosen_product.save
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
      @order_item.price *= @order_item.quantity
      chosen_product.stock -= params[:quantity].to_i
      if @order_item.save && chosen_product.stock >= 0 && chosen_product.save
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

  def shipped
    @order_item = Orderitem.find_by(id: params[:id])

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
        flash[:error] = "Current order status is #{@order_item.order_status.capitalize}, can't not change shipping status."
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
    @order_item = Orderitem.find_by(id: params[:id])

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
        flash[:error] = "Current order status is #{@order_item.order_status.capitalize}, can't not cancel the order."
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
    params.require(:order_item).permit(:quantity, :price, :product_id, :order_id, :order_status, :shipped, :cancelled)
  end
end
