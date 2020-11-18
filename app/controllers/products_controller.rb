class ProductsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def destroy
    if @product.nil? 
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
      return
    end
    
    if session[:user_id].nil?
      flash[:error] = "You must be logged in to delete this item"
      # need to clarify which path to redirect
      redirect_to login_path
      return
    elsif session[:user_id] == @product.user_id
      @product.destroy
      flash[:success] = "Successfully destroyed #{ @product.name }"
      # need to clarify which path to redirect
      redirect_to root_path
      return
    else
      flash[:error] = "Only the product merchant can delete the product."
      # need to clarify which path to redirect
      redirect_to root_path
      return
    end
  end
end