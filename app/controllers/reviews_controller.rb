class ReviewsController < ApplicationController

  def index
    # don't know if we need it or not
    @reviews = Review.all
  end

  def show
    # we don't need this?
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Your review has been successfully added"
      redirect_to product_path(@review.id)
    else
      flash[:error] = "Your review has not been added"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    if @review.nil?
      flash[:error] = "The review you are looking for is not found"
      redirect_to products_path
      return
    end
  end

  def update
    if @review.nil?
      flash[:error] = "The review you are looking for is not found"
      redirect_to products_path
      return
    elsif @review.update(review_params)
      flash[:success] = "Your review has been successfully updated"
      redirect_to product_path # go to the product details page
      return
    else # save failed
      flash.now[:error] = "Your review has not been updated"
      render :edit, status: :bad_request # show the new product form view again
      return
    end
  end

  def destroy
    if @review.nil? 
      render_404
      return
    end
   
    @review.destroy
    flash[:success] = "Successfully destroyed #{ @review.id }"
    # need to clarify which path to redirect
    redirect_back(fallback_location: root_path)
    return
  end
    
  private

  def find_review
    @review = Review.find_by(id: params[:id])
  end

  def review_params
    return params.require(:review).permit(:rating, :description)
  end
end
