class ProductsController < ApplicationController
  def index
  end

  def show
  end

  def new
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
end
