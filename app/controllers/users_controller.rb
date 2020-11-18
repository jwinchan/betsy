class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    elsif session[:id] != @user.id  # May need to change to current user
      flash[:error] = "You cannot see other users' information."
      # need to clarify which path to redirect
      redirect_to user_path(@user)
      return
    end
  end

  def edit
  end
end
