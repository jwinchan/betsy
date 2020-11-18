class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
  end

  def edit
  end
end
