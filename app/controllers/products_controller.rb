class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
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
    @product = Product.find_by(id: params[:id])
    driver_id = params[:id]

    begin
      @product = Product.find(driver_id)
    rescue ActiveRecord::RecordNotFound
      @product = nil
    end

    if @product.nil?
      head :not_found
      return
    end
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      head :not_found
      return
    elsif @product.update(
        name: params[:product][:name],
        vin: params[:product][:vin],
        available: params[:product][:available]
    )
      redirect_to driver_path # go to the product details page
      return
    else # save failed
    render :edit, status: :bad_request # show the new product form view again
    return
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
