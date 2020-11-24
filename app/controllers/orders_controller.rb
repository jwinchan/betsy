class OrdersController < ApplicationController
  def cart
  end
  
  def show
    @order = Order.find_by(id: params[:id])
    
    # For confirmed order
    if @order.nil?  
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return  
    elsif @order.products.where(user_id: session[:user_id]).empty?
      flash[:success] = "You don't have product sold in this Order."
      redirect_to root_path
      return 
    else
      flash[:success] = "Successfully load the Order fulfillment."
      redirect_to order_path(@order.id)
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
      if @order.save
        flash[:success] = "Your order was created."
        @order.mark_as_paid
        @order.update_stock
        redirect_to confirmation_path(@order.id)
        session[:order_id] = nil
        return
      else
        flash[:error] = "Your order was not created."
        redirect_to cart_path
        return
      end

  end

  def confirm

  end


  private
  def order_params
    return params.require(:order).permit(:order_item_id, :name, :email, :mailing_address, :cc_name, :cc_number, :cc_exp_date, :billing_zip_code)
  end

  def update_order

    @order.update(
        name: params[:name],
        email:params[:email],
        mailing_address: params[:mailing_address],
        cc_name:params[:name_on_credit_card],
        cc_number:params[:credit_card_number],
        cc_exp_date:params[:credit_card_expiration ],
        billing_zip_code:params[:billing_zipcode]
    )
  end
end
