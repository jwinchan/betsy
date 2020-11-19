class UsersController < ApplicationController


  before_action :find_user, only: [:show, :edit, :update]

 

  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    elsif session[:id] != @user.id  # May need to change to current user
      flash[:error] = "You cannot see other users' information."
      # need to clarify which path to redirect
      redirect_to root_path
      return
    end
  end

  def edit
    if @user.nil?
      flash[:error] = "User not found"
      redirect_to root_path
      return
    elsif @user.id != session[:user_id]
      flash[:error] = "You must log in as this user."
      redirect_to root_path
    end
  end

  def update
    if @user.nil?
      flash[:error] = "User not found"
      redirect_to users_path
      return
    elsif @user.update(user_params)
      flash[:success] = "User updated successfully"
      redirect_to user_path
      return
    else
      flash.now[:error] = "Something happened. User not updated."
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end


  private

  def find_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    return params.require(:user).permit(:name, :description, :uid, :provider, :email)
  end
end
