class ReviewsController < ApplicationController
  before_action :find_review

  def new
    @review = Review.new
    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      flash[:error] = "Couldn't find this product"
      redirect_to root_path
      return
    elsif @product.user_id == session[:user_id]
      flash[:error] = "You couldn't review your own products"
      redirect_to product_path(@product)
      return
    end
  end

  def create
    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      flash.now[:error] = "Couldn't find this product"
      redirect_to root_path
      return
    elsif @product.user_id == session[:user_id]
      flash[:error] = "You couldn't review your own products"
      redirect_to product_path(@product)
      return
    end

    @review = Review.new(review_params)
    @review.product_id = params[:product_id]

    if @review.save
      flash[:success] = "Your review has been successfully added"
      redirect_to product_path(@review.product_id)
    else
      flash[:error] = "Your review has not been added"
      redirect_to product_path(@review.product_id)
      return
    end
  end

  def edit
    if @review.nil?
      flash.now[:error] = "The review you are looking for is not found"
      render_404
      return
    end

    @product = Product.find_by(id: @review.product_id)
    if @product.user_id == session[:user_id]
      flash[:error] = "You couldn't edit the reviews for your own products"
      redirect_to product_path(@product)
      return
    end
  end

  def update
    if @review.nil?
      flash.now[:error] = "The review you are looking for is not found"
      render_404
      return
    end

    @product = Product.find_by(id: @review.product_id)
    if @product.user_id == session[:user_id]
      flash[:error] = "You couldn't edit the reviews for your own products"
      redirect_to product_path(@product)
      return
    elsif @review.update(review_params)
      flash[:success] = "Your review has been successfully updated"
      redirect_to product_path(@review.product_id)
      return
    else 
      flash.now[:error] = "Your review has not been updated"
      redirect_to product_path(@product)
      return
    end
  end

  def destroy
    if @review.nil? 
      flash.now[:error] = "The review you are looking for is not found"
      render_404
      return
    end
   
    @review.destroy
    flash[:success] = "Successfully destroyed #{ @review.id }"
    redirect_back(fallback_location: root_path)
    return
  end
    
  private

  def find_review
    @review = Review.find_by(id: params[:id])
  end

  def review_params
    return params.require(:review).permit(:product_id, :rating, :description)
  end
end
