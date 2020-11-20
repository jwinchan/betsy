class OrdersController < ApplicationController
  before_action :order_cart, only: [:create, :destroy]

  def cart
    @cart = Order.find_by(id: session[:order_id])
    if @cart.nil?
      @cart = Order.create
    end

    session[:order_id] = @cart.id
  end

  def show
    # May need different order status, order = true is ordered invoice, order = false is shopping cart, or add cart model & controller
    @order = Order.find_by(id: params[:id])
    @current_order = order_cart
    
    # For invoce
    if @order.nil?  
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return  
    elsif session[:user_id] != @order.user_id # Need to add user_id in orders table
      flash[:success] = "You cannot see other users' order."
      # need to clarify which path to redirect
      redirect_to products_path
      return
    else
      @order_show = @order 
      redirect_to order_path(@order.id)
      return 
    end
    
    # for shopping cart
    @order_show = @current_order  
  end


  private 
  def order_params
    return params.require(:order).permit(:order_item_id, :name, :email, :mailing_address, :cc_name, :cc_number, :cc_exp_date, billing_zip_code)
  end
end
