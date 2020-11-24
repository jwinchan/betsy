class OrdersController < ApplicationController
  def cart
  end
  
  def show
    @order = Order.find_by(id: params[:id])
    
    # For confirmed order
    if @order.nil?  
      render_404
      return  
    elsif @order.products.where(user_id: session[:user_id]).empty?
      flash[:success] = "You don't have product sold in this Order."
      redirect_to root_path
      return 
    end
  end

  def payment
    @order = Order.find_by(id: @cart.id)
    if @order.orderitems.empty?
      flash[:error] = "You have no items in your cart. Please get back to shopping!"
      redirect_to root_path
      return
    end
  end

  def complete
    @order = Order.find_by(id: @cart.id)

    update_order
    if @order.valid_check
      @order.save
      flash[:success] = "Your order was created."
      @order.mark_as_paid
      @order.update_stock
      redirect_to confirmation_path(@order.id)
      session[:order_id] = nil
      return
    else
      flash.now[:error] = "Your order was not created."
      render :payment
      return
    end
  end

  def confirm
    @order = Order.find_by(id: @cart.id)
  end


  private
  def order_params
    return params.require(:order).permit(:order_item_id, :name, :email, :mailing_address, :cc_name, :cc_number, :cc_exp_date, :billing_zip_code)
  end

  def update_order
    @order.update(
        name: params[:order][:name],
        email: params[:order][:email],
        mailing_address: params[:order][:mailing_address],
        cc_name: params[:order][:name_on_credit_card],
        cc_number: params[:order][:credit_card_number],
        cc_exp_date: params[:order][:credit_card_expiration],
        billing_zip_code: params[:order][:billing_zipcode]
    )
  end
end
