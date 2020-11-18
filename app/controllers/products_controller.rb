class ProductsController < ApplicationController
  before_action :find_product, only [:show, :edit, :update]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success = "Product has been successfully added"
      redirect_to product_path(@product.id)
    else
      flash[:error] = "Product has not been added"
      render :new, status: :bad_request
      return
    end
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
  private

  def find_product
    @product = Product.find_by_id(params[:id])
  end

  def product_params
    return params.require(:product).permit(:name, :stock, :price, :description, :photo_url, :user_id)
  end
end
