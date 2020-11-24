class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :retired]

  def index
    @products = Product.all
  end

  def show
    #review test with group
    # if @product.nil?
    #   head :not_found
    #   return
    # end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = session[:user_id]
    if @product.save
      flash[:success] = "Product has been successfully added"
      redirect_to product_path(@product.id)
    else
      flash[:error] = "Product has not been added"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    if @product.nil?
      flash[:error] = "Product not found"
      redirect_to products_path
      return

    end
  end

  def update

    if @product.nil?
      flash[:error] = "Product not found"
      redirect_to products_path
      return
    elsif @product.update(product_params)
      flash[:success] = "Product has been successfully updated"
      redirect_to product_path # go to the product details page
      return
    else # save failed
      flash.now[:error] = "Product has not been updated"
      render :edit, status: :bad_request # show the new product form view again
      return
    end
  end

  def destroy
    if @product.nil? 
      render_404
      return
    end
    
    if session[:user_id].nil?
      flash[:error] = "You must be logged in to delete this item"
      # need to clarify which path to redirect
      redirect_to products_path
      return
    elsif session[:user_id] == @product.user_id
      @product.update_attribute(:retired, true)
      @product.destroy
      flash[:success] = "Successfully destroyed #{ @product.name }"
      # need to clarify which path to redirect
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:error] = "Only the product Seller can delete the product."
      # need to clarify which path to redirect
      redirect_to root_path
      return
    end
  end

  def retired
    if @product.nil? 
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
      return
    end

    if session[:user_id].nil?
      flash[:error] = "You must be logged in to retire this item"
      redirect_to root_path
      return
    elsif session[:user_id] == @product.user_id
      if @product.retired
        @product.update_attribute(:retired, false)
        flash[:success] = "Successfully unretired #{ @product.name }"
        redirect_back(fallback_location: root_path)
        return
      else
        @product.update_attribute(:retired, true)
        flash[:success] = "Successfully retired #{ @product.name }"
        redirect_back(fallback_location: root_path)
        return
      end
    else
      flash[:error] = "Only the product Seller can delete the product."
      redirect_to root_path
      return
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    return params.require(:product).permit(:name, :stock, :price, :description, :photo_url, :user_id)
  end
end
