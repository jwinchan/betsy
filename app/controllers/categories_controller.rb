class CategoriesController < ApplicationController

  def create
    @category = Category.find_by(id: params[:id])

  end

end
