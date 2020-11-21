class OrdersController < ApplicationController

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


  private 
  def order_params
    return params.require(:order).permit(:order_item_id, :name, :email, :mailing_address, :cc_name, :cc_number, :cc_exp_date, billing_zip_code)
  end
end
