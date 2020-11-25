class CategoriesController < ApplicationController

  def create
    @category = Category.new(name: params[:name])
    if @category.save
      flash[:success] = "Category has been successfully added"
      redirect_to new_product_path
    else
      flash[:error] = "Product has not been added"
      redirect_to new_product_path
      return
    end
  end

end
